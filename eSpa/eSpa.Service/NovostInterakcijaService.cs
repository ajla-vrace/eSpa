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
    public class NovostInterakcijaService : BaseCRUDService<Model.NovostInterakcija, Database.NovostInterakcija, NovostInterakcijaSearchObject, NovostInterakcijaInsertRequest, NovostInterakcijaUpdateRequest>, INovostInterakcijaService
    {
        public NovostInterakcijaService(eSpaContext context, IMapper mapper) : base(context, mapper)
        {

        }
        public override IQueryable<Database.NovostInterakcija> AddFilter(IQueryable<Database.NovostInterakcija> query, NovostInterakcijaSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            // Ako je korisničko ime i naziv usluge uneseno
            if (!string.IsNullOrWhiteSpace(search?.Korisnik) && !string.IsNullOrWhiteSpace(search?.Novost))
            {
                string korisnikSearch = search.Korisnik.ToLower();
                string novostSearch = search.Novost.ToLower();
                filteredQuery = filteredQuery.Where(x =>
                    x.Korisnik.KorisnickoIme.ToLower() == (korisnikSearch) &&
                    x.Novost.Naslov.ToLower() == (novostSearch)
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
                    x.Novost.Naslov.ToLower() == (novostSearch)
                );
            }

            // Uključi povezane entitete
            filteredQuery = filteredQuery.Include(x => x.Korisnik)
                                         .Include(x => x.Novost);

            return filteredQuery;
        }
        public override async Task<Model.NovostInterakcija> Insert(NovostInterakcijaInsertRequest insert)
        {
            // Kreiraj novi entitet na osnovu request-a
            var entity = _mapper.Map<Database.NovostInterakcija>(insert);

            // Postavi trenutni datum
            entity.Datum = DateTime.Now;

            // Dodaj u bazu podataka
            _context.NovostInterakcijas.Add(entity);
            await _context.SaveChangesAsync();

            // Vrati mapirani model
            return _mapper.Map<Model.NovostInterakcija>(entity);
        }
        public override async Task<Model.NovostInterakcija> Update(int id, NovostInterakcijaUpdateRequest update)
        {
            var entity = await _context.NovostInterakcijas.FindAsync(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("NovostInterakcija nije pronađen.");
            }

            _mapper.Map(update, entity);
            entity.Datum = DateTime.Now;

            _context.NovostInterakcijas.Update(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.NovostInterakcija>(entity);
        }
    }
}
