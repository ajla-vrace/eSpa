using AutoMapper;
using eSpa.Model;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service.Database;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eSpa.Service
{
    public class KategorijaService : BaseCRUDService<Model.Kategorija, Database.Kategorija, KategorijaSearchObject,KategorijaInsertRequest,KategorijaUpdateRequest>, IKategorijaService
    {
        /* private readonly eSpaContext _context;
         public IMapper _mapper { get;set; }*/

        public KategorijaService(eSpaContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.Kategorija> AddFilter(IQueryable<Database.Kategorija> query, KategorijaSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                filteredQuery = filteredQuery.Where(x => x.Naziv.Contains(search.FTS));
            }



            return filteredQuery;
        }

        public async override Task<Model.Kategorija> Insert(KategorijaInsertRequest insert)
        {

            var entity = _mapper.Map<Database.Kategorija>(insert);

            //entity.Datum = DateTime.Now;

            _context.Kategorijas.Add(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Kategorija>(entity);

        }

        public override async Task<Model.Kategorija> Update(int id, KategorijaUpdateRequest update)
        {
            var entity = await _context.Kategorijas.FindAsync(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("Kategorija nije pronađena.");
            }

            _mapper.Map(update, entity);
            //entity.Datum = DateTime.Now;

            _context.Kategorijas.Update(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Kategorija>(entity);
        }

        public override async Task<Model.Kategorija> Delete(int id)
        {
            var entity = _context.Kategorijas.Find(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("Kategorija nije pronađena.");
            }

            _context.Kategorijas.Remove(entity);
            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Kategorija>(entity);
        }
    }
}
