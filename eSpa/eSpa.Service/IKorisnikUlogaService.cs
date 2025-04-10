using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Service
{
    public interface IKorisnikUlogaService : ICRUDService<Model.KorisnikUloga, KorisnikUlogaSearchObject, KorisnikUlogaInsertRequest, KorisnikUlogaUpdateRequest>
    {
    }
}
