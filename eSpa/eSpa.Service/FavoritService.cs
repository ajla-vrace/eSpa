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
    public class FavoritService : BaseCRUDService<Model.Favorit, Database.Favorit, FavoritSearchObject, FavoritInsertRequest, FavoritUpdateRequest>, IFavoritService
    {
        public FavoritService(eSpaContext context, IMapper mapper) : base(context, mapper)
        {

        }
       
      
        public override IQueryable<Database.Favorit> AddFilter(IQueryable<Database.Favorit> query, FavoritSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            // Ako je korisničko ime i naziv usluge uneseno
            if (!string.IsNullOrWhiteSpace(search?.Korisnik) && !string.IsNullOrWhiteSpace(search?.Usluga))
            {
                string korisnikSearch = search.Korisnik.ToLower();
                string uslugaSearch = search.Usluga.ToLower();
                filteredQuery = filteredQuery.Where(x =>
                    x.Korisnik.KorisnickoIme.ToLower() == (korisnikSearch) &&
                    x.Usluga.Naziv.ToLower()==(uslugaSearch)
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
            else if (!string.IsNullOrWhiteSpace(search?.Usluga))
            {
                string uslugaSearch = search.Usluga.ToLower();
                filteredQuery = filteredQuery.Where(x =>
                    x.Usluga.Naziv.ToLower()==(uslugaSearch)
                );
            }

            // Uključi povezane entitete
            filteredQuery = filteredQuery.Include(x => x.Korisnik)
                                         .Include(x => x.Usluga).ThenInclude(x => x.Kategorija);

            return filteredQuery;
        }

        public override async Task<Model.Favorit> Insert(FavoritInsertRequest insert)
        {
            // Kreiraj novi entitet na osnovu request-a
            var entity = _mapper.Map<Database.Favorit>(insert);

            // Postavi trenutni datum
            entity.Datum = DateTime.Now;

            // Dodaj u bazu podataka
            _context.Favorits.Add(entity);
            await _context.SaveChangesAsync();

            // Vrati mapirani model
            return _mapper.Map<Model.Favorit>(entity);
        }

        public override async Task<Model.Favorit> Update(int id, FavoritUpdateRequest update)
        {
            var entity = await _context.Favorits.FindAsync(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("Favorit nije pronađen.");
            }

            _mapper.Map(update, entity);
            entity.Datum = DateTime.Now;

            _context.Favorits.Update(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Favorit>(entity);
        }
    }
}
