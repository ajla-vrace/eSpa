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
    public class NovostKomentarService: BaseCRUDService<Model.NovostKomentar, Database.NovostKomentar, NovostKomentarSearchObject,NovostKomentarInsertRequest, NovostKomentarUpdateRequest>, INovostKomentarService
    {
        public NovostKomentarService(eSpaContext context, IMapper mapper) : base(context, mapper)
        {

        }
        public override IQueryable<Database.NovostKomentar> AddFilter(IQueryable<Database.NovostKomentar> query, NovostKomentarSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            // Ako je korisničko ime i naziv usluge uneseno
            if (!string.IsNullOrWhiteSpace(search?.Korisnik) && !string.IsNullOrWhiteSpace(search?.Novost))
            {
                string korisnikSearch = search.Korisnik.ToLower();
                string novostSearch = search.Novost.ToLower();
                filteredQuery = filteredQuery.Where(x =>
                    x.Korisnik.KorisnickoIme.ToLower().Contains(korisnikSearch) &&
                    x.Novost.Naslov.ToLower().Contains(novostSearch)
                );
            }
            // Ako je unesen samo username
            else if (!string.IsNullOrWhiteSpace(search?.Korisnik))
            {
                string korisnikSearch = search.Korisnik.ToLower();
                filteredQuery = filteredQuery.Where(x =>
                    x.Korisnik.KorisnickoIme.ToLower() == (korisnikSearch)
                );
            }
            // Ako je unesen samo naziv usluge
            else if (!string.IsNullOrWhiteSpace(search?.Novost))
            {
                string novostSearch = search.Novost.ToLower();
                filteredQuery = filteredQuery.Where(x =>
                    x.Novost.Naslov.ToLower().Contains(novostSearch)
                );
            }

            // Uključi povezane entitete
            filteredQuery = filteredQuery.Include(x => x.Korisnik)
                                         .Include(x => x.Novost);

            return filteredQuery;
        }
        public override async Task<Model.NovostKomentar> Insert(NovostKomentarInsertRequest insert)
        {
            // Kreiraj novi entitet na osnovu request-a
            var entity = _mapper.Map<Database.NovostKomentar>(insert);

            // Postavi trenutni datum
            entity.DatumKreiranja = DateTime.Now;

            // Dodaj u bazu podataka
            _context.NovostKomentars.Add(entity);
            await _context.SaveChangesAsync();

            // Vrati mapirani model
            return _mapper.Map<Model.NovostKomentar>(entity);
        }
        public override async Task<Model.NovostKomentar> Update(int id, NovostKomentarUpdateRequest update)
        {
            var entity = await _context.NovostKomentars.FindAsync(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("NovostKomentar nije pronađen.");
            }

            _mapper.Map(update, entity);
            entity.DatumKreiranja = DateTime.Now;

            _context.NovostKomentars.Update(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.NovostKomentar>(entity);
        }
    }
}
