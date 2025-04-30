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
using eSpa.Model;
namespace eSpa.Service
{
    public class KomentarService:BaseCRUDService<Model.Komentar,Database.Komentar,KomentarSearchObject,KomentarInsertRequest,KomentarUpdateRequest>, IKomentarService
    {
        public KomentarService(eSpaContext context, IMapper mapper) : base(context, mapper)
        {

        }
        /* public override IQueryable<Database.Komentar> AddFilter(IQueryable<Database.Komentar> query, KomentarSearchObject? search = null)
         {
             var filteredQuery = base.AddFilter(query, search);


             if (!string.IsNullOrWhiteSpace(search?.FTS))
             {
                 //filteredQuery = filteredQuery.Where(x => x.Tekst.Contains(search.FTS));
                 //filteredQuery = filteredQuery.Where(x => x.Tekst.ToLower().Contains(search.FTS.ToLower()));
                 filteredQuery = filteredQuery.Where(x => EF.Functions.Like(x.Tekst, $"%{search.FTS}%"));

             }

             filteredQuery = filteredQuery.Include(x => x.Korisnik)
                                 .Include(x => x.Usluga);


             return filteredQuery;
         }*/
        /*public override IQueryable<Database.Komentar> AddFilter(IQueryable<Database.Komentar> query, KomentarSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);


            if (!string.IsNullOrWhiteSpace(search?.Korisnik) ||
                     !string.IsNullOrWhiteSpace(search?.Usluga))
            {
                // Pretvori pretrage u lowercase za neosjetljivost na velika/mala slova
                string korisnikSearch = search?.Korisnik?.ToLower() ?? "";
                string uslugaSearch = search?.Usluga?.ToLower() ?? "";

                filteredQuery = filteredQuery.Where(x => x.Korisnik.KorisnickoIme.Contains(search.Korisnik) ||
                 x.Usluga.Naziv.Contains(search.Usluga)
                );
            }

            filteredQuery = filteredQuery.Include(x => x.Korisnik)
                                .Include(x => x.Usluga);


            return filteredQuery;
        }
        */
        public override IQueryable<Database.Komentar> AddFilter(IQueryable<Database.Komentar> query, KomentarSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            // Ako je korisničko ime i naziv usluge uneseno
            if (!string.IsNullOrWhiteSpace(search?.Korisnik) && !string.IsNullOrWhiteSpace(search?.Usluga))
            {
                string korisnikSearch = search.Korisnik.ToLower();
                string uslugaSearch = search.Usluga.ToLower();
                filteredQuery = filteredQuery.Where(x =>
                    x.Korisnik.KorisnickoIme.ToLower().Contains(korisnikSearch) &&
                    x.Usluga.Naziv.ToLower().Contains(uslugaSearch)
                );
            }
            // Ako je unesen samo username
            else if (!string.IsNullOrWhiteSpace(search?.Korisnik))
            {
                string korisnikSearch = search.Korisnik.ToLower();
                filteredQuery = filteredQuery.Where(x =>
                    x.Korisnik.KorisnickoIme.ToLower()==(korisnikSearch)
                );
            }
            // Ako je unesen samo naziv usluge
            else if (!string.IsNullOrWhiteSpace(search?.Usluga))
            {
                string uslugaSearch = search.Usluga.ToLower();
                filteredQuery = filteredQuery.Where(x =>
                    x.Usluga.Naziv.ToLower().Contains(uslugaSearch)
                );
            }

            // Uključi povezane entitete
            filteredQuery = filteredQuery.Include(x => x.Korisnik)
                                         .Include(x => x.Usluga).ThenInclude(x=>x.Kategorija);

            return filteredQuery;
        }

        /*public override Task<Model.Komentar> Insert(KomentarInsertRequest insert)
        {

            return base.Insert(insert);

        }*/
        public override async Task<Model.Komentar> Insert(KomentarInsertRequest insert)
        {
            // Kreiraj novi entitet na osnovu request-a
            var entity = _mapper.Map<Database.Komentar>(insert);

            // Postavi trenutni datum
            entity.Datum = DateTime.Now;

            // Dodaj u bazu podataka
            _context.Komentars.Add(entity);
            await _context.SaveChangesAsync();

            // Vrati mapirani model
            return _mapper.Map<Model.Komentar>(entity);
        }

        /*public override async Task<Model.Komentar> Update(int id, KomentarUpdateRequest update)
        {
            var entity = await _context.Komentars.FindAsync(id);

            return await base.Update(id, update);
        }*/
        public override async Task<Model.Komentar> Update(int id, KomentarUpdateRequest update)
        {
            var entity = await _context.Komentars.FindAsync(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("Komentar nije pronađen.");
            }

            _mapper.Map(update, entity);
            entity.Datum = DateTime.Now;

            _context.Komentars.Update(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Komentar>(entity);
        }
    }
}
