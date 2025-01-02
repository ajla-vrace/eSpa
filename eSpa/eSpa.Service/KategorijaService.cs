using AutoMapper;
using eSpa.Model;
using eSpa.Model.SearchObject;
using eSpa.Service.Database;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eSpa.Service
{
    public class KategorijaService : BaseService<Model.Kategorija, Database.Kategorija, KategorijaSearchObject>, IKategorijaService
    {
        /* private readonly eSpaContext _context;
         public IMapper _mapper { get;set; }*/

        public KategorijaService(eSpaContext context, IMapper mapper)
           : base(context, mapper)
        {

        }
        /*public KategorijaService(eSpaContext context, IMapper mapper):base(context,mapper)
        {
        }
        public override async Task<PagedResult<Model.Kategorija>> Get(KategorijaSearchObject? search)
        {
           
            var query = _context.Set<Database.Kategorija>().AsQueryable();
            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                query = query.Where(x => x.Naziv.StartsWith(search.Naziv));
            }
            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.Naziv.Contains(search.FTS));
            }
            var list=await query.ToListAsync();
           
            return _mapper.Map<PagedResult<Model.Kategorija>>(list);
        }*/

        public override IQueryable<Database.Kategorija> AddFilter(IQueryable<Database.Kategorija> query, KategorijaSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                query = query.Where(x => x.Naziv.StartsWith(search.Naziv));
            }

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.Naziv.Contains(search.FTS));
            }

            return base.AddFilter(query, search);
        }

        /* public List<Model.Kategorija> GetAllKategorija()
         {
             var entityList = _context.Kategorijas.ToList();
             var list=new List<Model.Kategorija>();
             foreach(var item in entityList)
             {
                 list.Add(new Model.Kategorija()
                 {
                     Naziv = item.Naziv,
                 });
             }
             return list;
         }*/
        /*public List<Model.Kategorija> Get()
        {
            var entityList= _context.Kategorijas.ToList();
            return _mapper.Map<List<Model.Kategorija>>(entityList);

        }*/ //bez async i await
            //ovo se brise jer se sada nasljedjuje baseservice
        /*public async Task<List<Model.Kategorija>> Get()
        {
            var entityList = await _context.Kategorijas.ToListAsync();
            return _mapper.Map<List<Model.Kategorija>>(entityList);

        }*/
        /*
        public async Task<IEnumerable<Database.Kategorija>> GetAll()
        {
            return await _context.Kategorijas.ToListAsync();  // Koristi DbSet Kategorijas
        }

        public async Task<Database.Kategorija> GetById(int id)
        {
            return await _context.Kategorijas.FindAsync(id);  // Koristi DbSet Kategorijas
        }

        public async Task<Database.Kategorija> AddKategorija(Database.Kategorija novaKategorija)
        {
            _context.Kategorijas.Add(novaKategorija);  // Dodavanje u DbSet Kategorijas
            await _context.SaveChangesAsync();
            return novaKategorija;
        }

        public async Task<Database.Kategorija> UpdateKategorija(int id, Database.Kategorija kategorija)
        {
            var existingKategorija = await _context.Kategorijas.FindAsync(id);  // Pronađi u Kategorijas
            if (existingKategorija == null) return null;

            existingKategorija.Naziv = kategorija.Naziv;

            await _context.SaveChangesAsync();
            return existingKategorija;
        }

        public async Task<bool> DeleteKategorija(int id)
        {
            var kategorija = await _context.Kategorijas.FindAsync(id);  // Pronađi u Kategorijas
            if (kategorija == null) return false;

            _context.Kategorijas.Remove(kategorija);  // Briši iz Kategorijas
            await _context.SaveChangesAsync();
            return true;
        }*/
    }
}
