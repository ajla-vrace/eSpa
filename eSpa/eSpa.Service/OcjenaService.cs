using AutoMapper;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service.Database;
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

            if (!string.IsNullOrWhiteSpace(search?.Ocjena) && int.TryParse(search.Ocjena, out int numericSearch))
            {
                filteredQuery = filteredQuery.Where(x => x.Ocjena1 == numericSearch);
            }

            /*if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                filteredQuery = filteredQuery.Where(x => x.Ocjena1.Contains(search.FTS));
            }*/



            return filteredQuery;
        }

        public async override Task<Model.Ocjena> Insert(OcjenaInsertRequest insert)
        {

            var entity = _mapper.Map<Database.Ocjena>(insert);

            entity.Datum = DateTime.Now;

            _context.Ocjenas.Add(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Ocjena>(entity);

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
