using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service;
using Microsoft.AspNetCore.Mvc;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KorisnikUlogaController : BaseCRUDController<Model.KorisnikUloga, KorisnikUlogaSearchObject, KorisnikUlogaInsertRequest, KorisnikUlogaUpdateRequest>
    {
        public KorisnikUlogaController(ILogger<BaseController<Model.KorisnikUloga, KorisnikUlogaSearchObject>> logger, IKorisnikUlogaService service) : base(logger, service)
        {

        }

    }
}
