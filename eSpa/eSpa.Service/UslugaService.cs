using AutoMapper;
using eSpa.Model;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Usluga = eSpa.Model.Usluga;

namespace eSpa.Service
{
    public class UslugaService : BaseCRUDService<Model.Usluga, Database.Usluga, Model.SearchObject.UslugaSearchObject, Model.Requests.UslugaInsertRequest, Model.Requests.UslugaUpdateRequest>, IUslugaService
    {
        public UslugaService(IB200069Context context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.Usluga> AddFilter(IQueryable<Database.Usluga> query, UslugaSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            /* if (!string.IsNullOrWhiteSpace(search?.FTS))
             {
                 filteredQuery = filteredQuery.Where(x => x.Naziv.Contains(search.FTS));
             }*/
            if (search != null)
            {
                if (!string.IsNullOrWhiteSpace(search.Naziv))
                {
                    filteredQuery = filteredQuery.Where(x => x.Naziv == (search.Naziv));
                }
                if (!string.IsNullOrWhiteSpace(search.Naziv1))
                {
                    filteredQuery = filteredQuery.Where(x => x.Naziv.Contains(search.Naziv1));
                }

                if (search.Cijena.HasValue) // Ako Cijena nije null
                {
                    filteredQuery = filteredQuery.Where(x => x.Cijena == search.Cijena.Value);
                }
                /*if (search.Cijena.HasValue)
                {
                    // Definiši toleranciju – podešavaj je prema potrebama tvoje aplikacije
                    double tolerance = 0.0001;
                    filteredQuery = filteredQuery.Where(x => Math.Abs(x.Cijena - search.Cijena.Value) < tolerance);
                }*/

                if (!string.IsNullOrWhiteSpace(search.Trajanje))
                {
                    filteredQuery = filteredQuery.Where(x => x.Trajanje.Contains(search.Trajanje));
                }
                if (!string.IsNullOrWhiteSpace(search.Kategorija))
                {
                    filteredQuery = filteredQuery.Where(x => x.Kategorija.Naziv.Contains(search.Kategorija));
                }
            }

            filteredQuery = filteredQuery
                .Include(x => x.Favorits)
                         .Include(x => x.Kategorija);

            return filteredQuery;
        }

        public override async Task<Model.Usluga> Insert(UslugaInsertRequest insert)
        {
            var entity = _mapper.Map<Database.Usluga>(insert);
            if (!string.IsNullOrEmpty(insert.SlikaBase64)) // Proverava da li nije null ili prazan string
            {
                entity.Slika = Convert.FromBase64String(insert.SlikaBase64); // Konvertuje sliku
            }
            else
            {
                entity.Slika = null; // Ako nije prosleđen base64 string, postavi sliku na null
            }
            var postojiUsluga = await _context.Uslugas
                                          .AnyAsync(u => u.Naziv == insert.Naziv);

            if (postojiUsluga)
            {
                throw new Exception("Usluga s ovim nazivom već postoji.");
            }

            _context.Uslugas.Add(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Usluga>(entity);

        }

        public override async Task<Model.Usluga> Update(int id, UslugaUpdateRequest update)
        {
            var entity = await _context.Uslugas.FindAsync(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("Usluga nije pronađena.");
            }
            if (!string.IsNullOrEmpty(update.SlikaBase64)) // Proverava da li nije null ili prazan string
            {
                entity.Slika = Convert.FromBase64String(update.SlikaBase64); // Konvertuje sliku
            }
            else
            {
                entity.Slika = null; // Ako nije prosleđen base64 string, postavi sliku na null
            }

            _mapper.Map(update, entity);

            _context.Uslugas.Update(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Usluga>(entity);
        }

        public override async Task<bool> Delete(int id)
        {
            var entity = await _context.Uslugas.FindAsync(id);

            if (entity == null)
                return false;

            // 1. Brišemo komentare vezane za uslugu
            var komentari = await _context.Komentars
                .Where(k => k.UslugaId == id)
                .ToListAsync();

            if (komentari.Any())
                _context.Komentars.RemoveRange(komentari);

            // 2. Brišemo ocjene vezane za uslugu
            var ocjene = await _context.Ocjenas
                .Where(o => o.UslugaId == id)
                .ToListAsync();

            if (ocjene.Any())
                _context.Ocjenas.RemoveRange(ocjene);

            // 3. Brišemo rezervacije vezane za uslugu
            var rezervacije = await _context.Rezervacijas
                .Where(r => r.UslugaId == id)
                .ToListAsync();

            if (rezervacije.Any())
                _context.Rezervacijas.RemoveRange(rezervacije);
            // 0. Brišemo favorite vezane za uslugu
            var favoriti = await _context.Favorits
                .Where(f => f.UslugaId == id)
                .ToListAsync();

            if (favoriti.Any())
                _context.Favorits.RemoveRange(favoriti);

            // 4. Brišemo samu uslugu
            _context.Uslugas.Remove(entity);

            await _context.SaveChangesAsync();

            return true;
        }




        public async Task<List<UslugaRezervacijaRequest>> GetRezervacijePoUslugama()
        {
            var query = _context.Rezervacijas
                .GroupBy(r => r.UslugaId)
                .Select(g => new UslugaRezervacijaRequest
                {
                    UslugaId = (int)g.Key,
                    Naziv = g.First().Usluga.Naziv,
                    Sifra = "U" + g.Key.ToString(),
                    BrojRezervacija = g.Count()
                });

            return await query.ToListAsync();
        }


       
        static MLContext mLContext = null;
        static object isLocked = new object();
        static ITransformer model = null;

        public List<Model.Usluga> Recommend(int uslugaId, int korisnikId)
        {
            var targetUsluga = _context.Uslugas.Include(x => x.Kategorija).FirstOrDefault(x => x.Id == uslugaId);
            if (targetUsluga == null)
                return new List<Model.Usluga>();

            var targetKategorijaId = targetUsluga.KategorijaId;

            bool korisnikImaOcjeneUKategoriji = _context.Ocjenas
                .Include(o => o.Usluga)
                .Any(o => o.KorisnikId == korisnikId && o.Usluga.KategorijaId == targetKategorijaId);

            if (!korisnikImaOcjeneUKategoriji)
            {
                // Nema ocjena u kategoriji, nema preporuka
                return new List<Model.Usluga>();
            }

            lock (isLocked)
            {
                if (mLContext == null)
                {
                    mLContext = new MLContext();

                    var tempData = _context.Ocjenas
                        .Include(x => x.Usluga)
                        .Where(o => o.KorisnikId == korisnikId && o.Usluga.KategorijaId == targetKategorijaId)
                        .ToList();

                    var uslugeList = _context.Uslugas.Where(u => u.KategorijaId == targetKategorijaId).ToList();
                    var data = new List<UslugaEntry>();

                    foreach (var rec in tempData)
                    {
                        foreach (var item in uslugeList)
                        {
                            if (item.Id != rec.UslugaId)
                            {
                                data.Add(new UslugaEntry { UslugaId = (uint)rec.UslugaId, CoUsluga_Id = (uint)item.Id, Label = 1f });
                            }
                        }
                    }

                    if (data.Count != 0)
                    {
                        var trainData = mLContext.Data.LoadFromEnumerable(data);

                        var options = new MatrixFactorizationTrainer.Options
                        {
                            MatrixColumnIndexColumnName = nameof(UslugaEntry.UslugaId),
                            MatrixRowIndexColumnName = nameof(UslugaEntry.CoUsluga_Id),
                            LabelColumnName = nameof(UslugaEntry.Label),
                            LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                            Alpha = 0.01,
                            Lambda = 0.025,
                            NumberOfIterations = 100,
                            C = 0.00001
                        };

                        var est = mLContext.Recommendation().Trainers.MatrixFactorization(options);
                        model = est.Fit(trainData);
                    }
                }
            }

            var usluge = _context.Uslugas
                .Include(x => x.Favorits)
                .Include(x => x.Kategorija)
                .Where(x => x.Id != uslugaId && x.KategorijaId == targetKategorijaId);

            var predictionResult = new List<Tuple<Database.Usluga, float>>();

            if (model != null)
            {
                var predictionengine = mLContext.Model.CreatePredictionEngine<UslugaEntry, CoUsluga_Prediction>(model);

                foreach (var usluga in usluge)
                {
                    var prediction = predictionengine.Predict(
                        new UslugaEntry()
                        {
                            UslugaId = (uint)uslugaId,
                            CoUsluga_Id = (uint)usluga.Id
                        });

                    predictionResult.Add(new Tuple<Database.Usluga, float>(usluga, prediction.Score));
                }

                // Uzmi top 3 sa najvećim score
                var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(3).ToList();

                mLContext = null;
                model = null;
                return _mapper.Map<List<Model.Usluga>>(finalResult);
            }
            else
            {
                mLContext = null;
                model = null;
                return new List<Model.Usluga>();
            }
        }

        public class CoUsluga_Prediction
        {
            public float Score { get; set; }
        }

        public class UslugaEntry
        {
            [KeyType(count: 100)]
            public uint UslugaId { get; set; }

            [KeyType(count: 100)]
            public uint CoUsluga_Id { get; set; }

            public float Label { get; set; }
        }






    }
}
    
