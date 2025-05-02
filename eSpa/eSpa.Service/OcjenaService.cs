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
    public class OcjenaService:BaseCRUDService<Model.Ocjena,Database.Ocjena,OcjenaSearchObject,OcjenaInsertRequest,OcjenaUpdateRequest>,IOcjenaService
    {
        public OcjenaService(eSpaContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.Ocjena> AddFilter(IQueryable<Database.Ocjena> query, OcjenaSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Korisnik))
            {
                var korisnikSearch = search.Korisnik.ToLower();
                filteredQuery = filteredQuery.Where(x =>
                    x.Korisnik.KorisnickoIme.ToLower().Contains(korisnikSearch));
            }

            if (!string.IsNullOrWhiteSpace(search?.Usluga))
            {
                var uslugaSearch = search.Usluga.ToLower();
                filteredQuery = filteredQuery.Where(x =>
                    x.Usluga.Naziv.ToLower().Contains(uslugaSearch));
            }

            if (search?.Ocjena.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.Ocjena1 == search.Ocjena.Value);
            }

            // Uključi povezane entitete
            filteredQuery = filteredQuery.Include(x => x.Korisnik)
                                         .Include(x => x.Usluga).ThenInclude(x => x.Kategorija);

            return filteredQuery;
        }

        /*public async override Task<Model.Ocjena> Insert(OcjenaInsertRequest insert)
        {

            var entity = _mapper.Map<Database.Ocjena>(insert);

            entity.Datum = DateTime.Now;

            _context.Ocjenas.Add(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Ocjena>(entity);

        }*/
        public async override Task<Model.Ocjena> Insert(OcjenaInsertRequest insert)
        {
            // Pronađi postojeću ocjenu za korisnika i uslugu
            var existingOcjena = await _context.Ocjenas
                .FirstOrDefaultAsync(o => o.KorisnikId == insert.KorisnikId && o.UslugaId == insert.UslugaId);

            if (existingOcjena != null)
            {
                // Ako postoji, ažuriraj postojeću ocjenu
                existingOcjena.Ocjena1 = insert.Ocjena1;  // Pretpostavljamo da `Ocjena1` predstavlja samu ocjenu
                existingOcjena.Datum = DateTime.Now;  // Ažuriraj datum ako je potrebno

                await _context.SaveChangesAsync();  // Spremi promene u bazi
                return _mapper.Map<Model.Ocjena>(existingOcjena);  // Vrati mapirani objekat iz baze
            }
            else
            {
                // Ako ne postoji, dodaj novu ocjenu
                var entity = _mapper.Map<Database.Ocjena>(insert);  // Mapiraj novi unos
                entity.Datum = DateTime.Now;  // Postavi datum

                _context.Ocjenas.Add(entity);  // Dodaj novu ocjenu u bazu
                await _context.SaveChangesAsync();  // Spremi promene u bazi

                return _mapper.Map<Model.Ocjena>(entity);  // Vrati mapirani objekat iz baze
            }
        }



        public override async Task<Model.Ocjena> Update(int id, OcjenaUpdateRequest update)
        {
            var entity = await _context.Ocjenas.FindAsync(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("Ocjena nije pronađena.");
            }

            _mapper.Map(update, entity);
            entity.Datum = DateTime.Now;

            _context.Ocjenas.Update(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Ocjena>(entity);
        }

    }
}
