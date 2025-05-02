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
    public class UslugaService : BaseCRUDService<Model.Usluga, Database.Usluga, Model.SearchObject.UslugaSearchObject, Model.Requests.UslugaInsertRequest, Model.Requests.UslugaUpdateRequest>, IUslugaService
    {
        public UslugaService(eSpaContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.Usluga> AddFilter(IQueryable<Database.Usluga> query, UslugaSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            /* if (!string.IsNullOrWhiteSpace(search?.FTS))
             {
                 filteredQuery = filteredQuery.Where(x => x.Naziv.Contains(search.FTS));
             }*/
            if (search != null)
            {
                if (!string.IsNullOrWhiteSpace(search.Naziv))
                {
                    filteredQuery = filteredQuery.Where(x => x.Naziv.Contains(search.Naziv));
                }

                if (search.Cijena.HasValue) // Ako Cijena nije null
                {
                    filteredQuery = filteredQuery.Where(x => x.Cijena == search.Cijena.Value);
                }
                /*if (search.Cijena.HasValue)
                {
                    // Definiši toleranciju – podešavaj je prema potrebama tvoje aplikacije
                    double tolerance = 0.0001;
                    filteredQuery = filteredQuery.Where(x => Math.Abs(x.Cijena - search.Cijena.Value) < tolerance);
                }*/

                if (!string.IsNullOrWhiteSpace(search.Trajanje))
                {
                    filteredQuery = filteredQuery.Where(x => x.Trajanje.Contains(search.Trajanje));
                }
                if (!string.IsNullOrWhiteSpace(search.Kategorija))
                {
                    filteredQuery = filteredQuery.Where(x => x.Kategorija.Naziv.Contains(search.Kategorija));
                }
            }

            filteredQuery = filteredQuery
                         .Include(x => x.Kategorija);

            return filteredQuery;
        }

        public override async Task<Model.Usluga> Insert(UslugaInsertRequest insert)
        {
            var entity = _mapper.Map<Database.Usluga>(insert);
            entity.Slika = Convert.FromBase64String(insert.SlikaBase64);
            _context.Uslugas.Add(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Usluga>(entity);

        }

        public override async Task<Model.Usluga> Update(int id, UslugaUpdateRequest update)
        {
            var entity = await _context.Uslugas.FindAsync(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("Usluga nije pronađena.");
            }
            entity.Slika = Convert.FromBase64String(update.SlikaBase64);
            _mapper.Map(update, entity);

            _context.Uslugas.Update(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Usluga>(entity);
        }


    }
}
