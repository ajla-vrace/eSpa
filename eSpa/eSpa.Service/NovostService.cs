using AutoMapper;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eSpa.Model;
namespace eSpa.Service
{
    public class NovostService:BaseCRUDService<Model.Novost,Database.Novost,NovostSearchObject,NovostInsertRequest,NovostUpdateRequest>,INovostService
    {
        public NovostService(eSpaContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.Novost> AddFilter(IQueryable<Database.Novost> query, NovostSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                filteredQuery = filteredQuery.Where(x => x.Naslov.Contains(search.FTS));
            }



            return filteredQuery;
        }

        public async override Task<Model.Novost> Insert(NovostInsertRequest insert)
        {

            var entity = _mapper.Map<Database.Novost>(insert);

            entity.Datum = DateTime.Now;

            _context.Novosts.Add(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Novost>(entity);

        }

        public override async Task<Model.Novost> Update(int id, NovostUpdateRequest update)
        {
            var entity = await _context.Novosts.FindAsync(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("Novost nije pronađena.");
            }

            _mapper.Map(update, entity);
            entity.Datum = DateTime.Now;

            _context.Novosts.Update(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Novost>(entity);
        }

        public override async Task<Model.Novost> Delete(int id)
        {
            var entity = _context.Novosts.Find(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("Novost nije pronađena.");
            }

            _context.Novosts.Remove(entity);
           await  _context.SaveChangesAsync();
            return _mapper.Map<Model.Novost>(entity);
        }
    }
}
