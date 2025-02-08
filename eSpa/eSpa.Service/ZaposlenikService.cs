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
        public ZaposlenikService(eSpaContext1 context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.Zaposlenik> AddFilter(IQueryable<Database.Zaposlenik> query, ZaposlenikSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                filteredQuery = filteredQuery.Where(x => x.Struka.Contains(search.FTS));
            }

            filteredQuery = filteredQuery.Include(x => x.Korisnik); //dodano

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

        public override async Task<Model.Zaposlenik> Update(int id, ZaposlenikUpdateRequest update)
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
        }

        public override async Task<Model.Zaposlenik> Delete(int id)
        {
            var entity = _context.Zaposleniks.Find(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("Zaposlenik nije pronađen.");
            }

            _context.Zaposleniks.Remove(entity);
            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Zaposlenik>(entity);
        }
    }
}
