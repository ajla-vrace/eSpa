using AutoMapper;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service.Database;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Service
{
    public class UlogaService : BaseCRUDService<Model.Uloga, Database.Uloga, UlogaSearchObject, UlogaInsertRequest, UlogaUpdateRequest>, IUlogaService
    {

        public UlogaService(eSpaContext context, IMapper mapper) : base(context, mapper)
        {

        }
    }
}
