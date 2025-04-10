using AutoMapper;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Service
{
    public class ZaposlenikService : BaseCRUDService<Model.Zaposlenik, Database.Zaposlenik, ZaposlenikSearchObject, ZaposlenikInsertRequest, ZaposlenikUpdateRequest>, IZaposlenikService
    {
        public ZaposlenikService(eSpaContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.Zaposlenik> AddFilter(IQueryable<Database.Zaposlenik> query, ZaposlenikSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Ime))
            {
                filteredQuery = filteredQuery.Where(x => x.Korisnik.Ime.Contains(search.Ime));
            }
            if (!string.IsNullOrWhiteSpace(search?.Prezime))
            {
                filteredQuery = filteredQuery.Where(x => x.Korisnik.Prezime.Contains(search.Prezime));
            }
            if (!string.IsNullOrWhiteSpace(search?.KorisnickoIme))
            {
                filteredQuery = filteredQuery.Where(x => x.Korisnik.KorisnickoIme.Contains(search.KorisnickoIme));
            }
            if (!string.IsNullOrWhiteSpace(search?.Uloga))
            {
                filteredQuery = filteredQuery.Where(x =>
                    x.Korisnik.KorisnikUlogas.Any(ku => ku.Uloga.Naziv.Contains(search.Uloga))
                );
            }

            // filteredQuery = filteredQuery.Include(x => x.Korisnik); //dodano
            /*filteredQuery = filteredQuery
                    .Include(x => x.Korisnik)
                        .Include(x => x.Slika);*/
            filteredQuery = filteredQuery
      .Include(x => x.Korisnik)
          .ThenInclude(k => k.KorisnikUlogas)
              .ThenInclude(ku => ku.Uloga)
      .Include(x => x.Slika);


            return filteredQuery;
        }

        public async override Task<Model.Zaposlenik> Insert(ZaposlenikInsertRequest insert)
        {

            var entity = _mapper.Map<Database.Zaposlenik>(insert);

            //entity.DatumZaposlenja = DateTime.Now;

            _context.Zaposleniks.Add(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Zaposlenik>(entity);
        }

        /* public override async Task<Model.Zaposlenik> Update(int id, ZaposlenikUpdateRequest update)
         {
             var entity = await _context.Zaposleniks.FindAsync(id);
             if (entity == null)
             {
                 throw new KeyNotFoundException("Zaposlenik nije pronađen.");
             }

             _mapper.Map(update, entity);
             //entity.DatumZaposlenja = DateTime.Now;

             _context.Zaposleniks.Update(entity);
             await _context.SaveChangesAsync();

             return _mapper.Map<Model.Zaposlenik>(entity);
         }*/


        /*
        public override async Task<Model.Zaposlenik> Update(int id, ZaposlenikUpdateRequest update)
        {
            var entity = await _context.Zaposleniks.FindAsync(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("Zaposlenik nije pronađen.");
            }

            // Mapiraj sve ostale podatke
            _mapper.Map(update, entity);

            // Ako je poslano novo SlikaId, ažuriraj ga
            if (update.SlikaId.HasValue && update.SlikaId != entity.SlikaId)
            {
                // Ako već postoji stara slika, brišemo vezu prema njoj (ali ne brišemo sliku iz baze)
                if (entity.SlikaId.HasValue)
                {
                    entity.SlikaId = null;
                }

                // Dodaj novu vezu prema slici
                entity.SlikaId = update.SlikaId;
            }

            // Spasi promjene
            _context.Zaposleniks.Update(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Zaposlenik>(entity);
        }
        */



        public override async Task<Model.Zaposlenik> Update(int id, ZaposlenikUpdateRequest update)
        {
            /* var entity = await _context.Zaposleniks
                 .FindAsync(id);*/
            var entity = await _context.Zaposleniks
                        .Include(z => z.Korisnik)
                    .FirstOrDefaultAsync(z => z.Id == id);

            if (entity == null)
            {
                throw new KeyNotFoundException("Zaposlenik nije pronađen.");
            }

            // Mapiraj ostale podatke

            if (!string.IsNullOrWhiteSpace(update.Ime) && update.Ime != entity.Korisnik.Ime)
            {
                entity.Korisnik.Ime = update.Ime;
            }

            if (!string.IsNullOrWhiteSpace(update.Prezime) && update.Prezime != entity.Korisnik.Prezime)
            {
                entity.Korisnik.Prezime = update.Prezime;
            }
            // Ako dolazi nova slika
            if (update.SlikaId.HasValue && update.SlikaId != entity.SlikaId)
            {
                // Ako već postoji stara slika, brišemo je iz baze
                if (entity.SlikaId.HasValue)
                {
                    var staraSlika = await _context.ZaposlenikSlikes.FindAsync(entity.SlikaId.Value);
                    if (staraSlika != null)
                    {
                        _context.ZaposlenikSlikes.Remove(staraSlika);
                    }
                }

                // Dodaj novu vezu prema slici
                entity.SlikaId = update.SlikaId;
                
            }
            _mapper.Map(update, entity);
            entity.Status=update.Status;
            // Spasi promjene
            _context.Zaposleniks.Update(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Zaposlenik>(entity);
        }



        /*public override async Task<Model.Zaposlenik> Delete(int id)
        {
            var entity = _context.Zaposleniks.Find(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("Zaposlenik nije pronađen.");
            }

            _context.Zaposleniks.Remove(entity);
            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Zaposlenik>(entity);
        }*/
        public override async Task<Model.Zaposlenik> Delete(int id)
        {
            var entity = _context.Zaposleniks.Find(id);

            if (entity == null)
            {
                throw new KeyNotFoundException("Zaposlenik nije pronađen.");
            }

            //  Ako zaposlenik ima sliku, brišemo i sliku
            if (entity.SlikaId != null)
            {
                var slikaEntity = await _context.ZaposlenikSlikes.FindAsync(entity.SlikaId);
                if (slikaEntity != null)
                {
                    _context.ZaposlenikSlikes.Remove(slikaEntity);
                }
            }

            //  Brišemo povezanog korisnika
            var korisnikEntity = await _context.Korisniks.FindAsync(entity.KorisnikId);
            var korisnikUloge = await _context.KorisnikUlogas
      .Where(ku => ku.KorisnikId == entity.KorisnikId)
      .ToListAsync();

            if (korisnikUloge.Any())
            {
                _context.KorisnikUlogas.RemoveRange(korisnikUloge);  // Brišemo sve povezane uloge
            }
            if (korisnikEntity != null)
            {
                _context.Korisniks.Remove(korisnikEntity);
            }

            //  Brišemo zaposlenika
            _context.Zaposleniks.Remove(entity);

            //  Spremamo promjene
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Zaposlenik>(entity);
        }

    }
}
