using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using eSpa.Model;
using eSpa.Model.SearchObject;
using eSpa.Service.Database;

namespace eSpa.Service
{
    public class StatusRezervacijeService:BaseService<Model.StatusRezervacije,Database.StatusRezervacije,StatusRezervacijeSearchObject>,IStatusRezervacijeService
    {
        public StatusRezervacijeService(IB200069Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.StatusRezervacije> AddFilter(IQueryable<Database.StatusRezervacije> query, StatusRezervacijeSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                filteredQuery = filteredQuery.Where(x => x.Naziv==(search.Naziv));
            }
            return filteredQuery;
        }


    }
}
