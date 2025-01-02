using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Service
{
    public interface IUslugaService: ICRUDService<Model.Usluga,Model.SearchObject.UslugaSearchObject,Model.Requests.UslugaInsertRequest,Model.Requests.UslugaUpdateRequest>
    {
    }
}
