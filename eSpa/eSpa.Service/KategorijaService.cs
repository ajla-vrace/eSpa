using AutoMapper;
using eSpa.Model;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service.Database;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace eSpa.Service
{
    public class KategorijaService : BaseCRUDService<Model.Kategorija, Database.Kategorija, KategorijaSearchObject,KategorijaInsertRequest,KategorijaUpdateRequest>, IKategorijaService
    {
        /* private readonly eSpaContext _context;
         public IMapper _mapper { get;set; }*/
        private readonly IUslugaService _uslugaService;
        private readonly IZaposlenikService _zaposlenikService;
        public KategorijaService(IB200069Context context, IMapper mapper, IUslugaService uslugaService,
    IZaposlenikService zaposlenikService) : base(context, mapper)
        {
            _uslugaService = uslugaService;
            _zaposlenikService = zaposlenikService;

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

        public override async Task<bool> Delete(int id)
        {
            var kategorija = await _context.Kategorijas.FindAsync(id);
            if (kategorija == null)
                return false;

            // 1. Pronađi sve usluge te kategorije
            var usluge = await _context.Uslugas
                .Where(u => u.KategorijaId == id)
                .ToListAsync();

            foreach (var usluga in usluge)
            {
                await _uslugaService.Delete(usluga.Id); // koristi servis
            }

            // 2. Pronađi sve zaposlenike koji pripadaju toj kategoriji
            var zaposlenici = await _context.Zaposleniks
                .Where(z => z.KategorijaId == id)
                .ToListAsync();

            foreach (var zaposlenik in zaposlenici)
            {
                await _zaposlenikService.Delete(zaposlenik.Id); // koristi servis
            }

            // 3. (Opcionalno) briši direktno rezervacije koje su vezane za kategoriju ali ne kroz uslugu
            // Ako nema takvih slučajeva, ovo možeš preskočiti

            // 4. Briši kategoriju
            _context.Kategorijas.Remove(kategorija);
            await _context.SaveChangesAsync();

            return true;
        }


    }
}
