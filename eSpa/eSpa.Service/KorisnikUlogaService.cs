using AutoMapper;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service.Database;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Service
{
    public class KorisnikUlogaService : BaseCRUDService<Model.KorisnikUloga, Database.KorisnikUloga, KorisnikUlogaSearchObject, KorisnikUlogaInsertRequest, KorisnikUlogaUpdateRequest>, IKorisnikUlogaService
    {

        public KorisnikUlogaService(eSpaContext context, IMapper mapper) : base(context, mapper)
        {
        
        }
        /*public override IQueryable<Database.KorisnikUloga> AddInclude(IQueryable<Database.KorisnikUloga> query, KorisnikUlogaSearchObject? search = null)
        {
            // query = query.Include(ku => ku.Uloga);  // Dodaj ulogu


            //query = query.Include(ku => ku.Uloga);

            // Dodaj korisnika
           // query = query.Include(ku => ku.Korisnik);
            return base.AddInclude(query, search);
        }*/


        /* public override async Task<Model.KorisnikUloga> Insert(KorisnikUlogaInsertRequest request)
         {
             // Pronađi postojeću ulogu korisnika
             var postojećaUloga = _context.KorisnikUlogas
                 .FirstOrDefault(ku => ku.KorisnikId == request.KorisnikId);

             // Ako korisnik nema ulogu ili ima drugačiju ulogu, ažuriraj
             if (postojećaUloga == null || postojećaUloga.UlogaId != request.UlogaId)
             {
                 // Ako korisnik ima ulogu, izbriši staru
                 if (postojećaUloga != null)
                 {
                     _context.KorisnikUlogas.Remove(postojećaUloga);
                     await _context.SaveChangesAsync();
                 }

                 // Ako nije odabrana nova uloga, postavi default "Terapeut"
                 var novaUlogaId = request.UlogaId;
                /* if (novaUlogaId == null)
                 {
                     var defaultUloga = _context.Ulogas.FirstOrDefault(u => u.Naziv.ToLower() == "terapeut");
                     novaUlogaId = defaultUloga?.Id;
                 }*/

        // Kreiraj novu ulogu za korisnika
        /* var novaKorisnikUloga = new Database.KorisnikUloga
          {
              KorisnikId = request.KorisnikId,
              UlogaId = novaUlogaId
          };

          _context.KorisnikUlogas.Add(novaKorisnikUloga);
          await _context.SaveChangesAsync();

          return _mapper.Map<Model.KorisnikUloga>(novaKorisnikUloga);
      }

      // Ako korisnik već ima tu istu ulogu, samo vrati postojeću
      return _mapper.Map<Model.KorisnikUloga>(postojećaUloga);
  }*/
        public override async Task<Model.KorisnikUloga> Insert(KorisnikUlogaInsertRequest request)
        {
            // Pronađi postojeću ulogu korisnika
            var postojećaUloga = await _context.KorisnikUlogas
                .FirstOrDefaultAsync(ku => ku.KorisnikId == request.KorisnikId);

            // Ako korisnik već ima tu istu ulogu, nema potrebe za promjenom
            if (postojećaUloga != null && postojećaUloga.UlogaId == request.UlogaId)
            {
                return _mapper.Map<Model.KorisnikUloga>(postojećaUloga);
            }

            // Ako korisnik ima drugu ulogu, obriši staru ulogu
            if (postojećaUloga != null && postojećaUloga.UlogaId != request.UlogaId)
            {
                _context.KorisnikUlogas.Remove(postojećaUloga);
                await _context.SaveChangesAsync();
            }

            // Dodaj novu ulogu za korisnika
            var novaKorisnikUloga = new Database.KorisnikUloga
            {
                KorisnikId = request.KorisnikId,
                UlogaId = request.UlogaId
            };

            _context.KorisnikUlogas.Add(novaKorisnikUloga);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.KorisnikUloga>(novaKorisnikUloga);
        }




        /*
        public override async Task<Model.KorisnikUloga> Insert(KorisnikUlogaInsertRequest request)
        {
            // Pronađi postojeću ulogu korisnika
            var postojećaUloga = _context.KorisnikUlogas
                .FirstOrDefault(ku => ku.KorisnikId == request.KorisnikId);

            // Ako korisnik nema ulogu ili ima drugačiju ulogu, ažuriraj
            if (postojećaUloga == null || postojećaUloga.UlogaId != request.UlogaId)
            {
                // Ako korisnik ima ulogu, izbriši staru
                if (postojećaUloga != null)
                {
                    _context.KorisnikUlogas.Remove(postojećaUloga);
                    await _context.SaveChangesAsync();
                }

                // Ako nije odabrana nova uloga, postavi default "Terapeut"
                var novaUlogaId = request.UlogaId;

                if (novaUlogaId == null)
                {
                    var defaultUloga = _context.Ulogas.FirstOrDefault(u => u.Naziv.ToLower() == "terapeut");
                    novaUlogaId = (int)(defaultUloga?.Id);
                }

                // Kreiraj novu ulogu za korisnika
                var novaKorisnikUloga = new Database.KorisnikUloga
                {
                    KorisnikId = request.KorisnikId,
                    UlogaId = novaUlogaId,
                    DatumDodele = DateTime.Now // Postavite datum dodele, ako je potrebno
                };

                _context.KorisnikUlogas.Add(novaKorisnikUloga);
                await _context.SaveChangesAsync();

                return _mapper.Map<Model.KorisnikUloga>(novaKorisnikUloga);
            }

            // Ako korisnik već ima tu istu ulogu, samo vrati postojeću
            return _mapper.Map<Model.KorisnikUloga>(postojećaUloga);
        }

        */






        /*public override IQueryable<Database.KorisnikUloga> AddInclude(IQueryable<Database.KorisnikUloga> query, KorisnikUlogaSearchObject? search = null)
        {
            if (search. == true)
            {
                query = query.Include(role => role.Uloga);
            }

            return base.AddInclude(query, search);
        }*/



    }
}
