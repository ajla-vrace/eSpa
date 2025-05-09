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
    public class ZaposlenikRecenzijaService : BaseCRUDService<Model.ZaposlenikRecenzija, Database.ZaposlenikRecenzija, ZaposlenikRecenzijaSearchObject, ZaposlenikRecenzijaInsertRequest, ZaposlenikRecenzijaUpdateRequest>, IZaposlenikRecenzijaService
    {
        public ZaposlenikRecenzijaService(eSpaContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.ZaposlenikRecenzija> AddFilter(IQueryable<Database.ZaposlenikRecenzija> query, ZaposlenikRecenzijaSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            // Ako je korisničko ime i naziv usluge uneseno
            if (!string.IsNullOrWhiteSpace(search?.Korisnik) && !string.IsNullOrWhiteSpace(search?.Zaposlenik))
            {
                string korisnikSearch = search.Korisnik.ToLower();
                string zaposlenikSearch = search.Zaposlenik.ToLower();
                filteredQuery = filteredQuery.Where(x =>
                    x.Korisnik.KorisnickoIme.ToLower()==(korisnikSearch) &&
                    x.Zaposlenik.Korisnik.KorisnickoIme.ToLower()==(zaposlenikSearch)
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
            else if (!string.IsNullOrWhiteSpace(search?.Zaposlenik))
            {
                string uslugaSearch = search.Zaposlenik.ToLower();
                filteredQuery = filteredQuery.Where(x =>
                    x.Zaposlenik.Korisnik.KorisnickoIme.ToLower()==(uslugaSearch)
                );
            }

            // Uključi povezane entitete
            filteredQuery = filteredQuery.Include(x => x.Korisnik)
                                         .Include(x => x.Zaposlenik).ThenInclude(x => x.Korisnik)
                                         .Include(x => x.Zaposlenik).ThenInclude(x => x.Kategorija);

            return filteredQuery;
        }

        public override async Task<Model.ZaposlenikRecenzija> Insert(ZaposlenikRecenzijaInsertRequest insert)
        {
            // Kreiraj novi entitet na osnovu request-a
            var entity = _mapper.Map<Database.ZaposlenikRecenzija>(insert);

            // Postavi trenutni datum
            entity.DatumKreiranja = DateTime.Now;

            // Dodaj u bazu podataka
            _context.ZaposlenikRecenzijas.Add(entity);
            await _context.SaveChangesAsync();

            // Vrati mapirani model
            return _mapper.Map<Model.ZaposlenikRecenzija>(entity);
        }

     
        public override async Task<Model.ZaposlenikRecenzija> Update(int id, ZaposlenikRecenzijaUpdateRequest update)
        {
            var entity = await _context.ZaposlenikRecenzijas.FindAsync(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("Recenzija nije pronađen.");
            }

            _mapper.Map(update, entity);
            entity.DatumKreiranja = DateTime.Now;

            _context.ZaposlenikRecenzijas.Update(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.ZaposlenikRecenzija>(entity);
        }
    }
}
