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
    public class UslugaService : BaseCRUDService<Model.Usluga, Database.Usluga, Model.SearchObject.UslugaSearchObject, Model.Requests.UslugaInsertRequest, Model.Requests.UslugaUpdateRequest>, IUslugaService
    {
        public UslugaService(eSpaContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.Usluga> AddFilter(IQueryable<Database.Usluga> query, UslugaSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                filteredQuery = filteredQuery.Where(x => x.Naziv.Contains(search.FTS));
            }



            return filteredQuery;
        }

        public override Task<Model.Usluga> Insert(UslugaInsertRequest insert)
        {

            return base.Insert(insert);

        }

        public override async Task<Model.Usluga> Update(int id, UslugaUpdateRequest update)
        {
            var entity = await _context.Uslugas.FindAsync(id);

            return await base.Update(id, update);
        }


    }
}
