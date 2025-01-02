using eSpa.Service;
using eSpa.Model;
using Microsoft.AspNetCore.Mvc;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KorisniciController : BaseCRUDController<Model.Korisnik, Model.SearchObject.KorisnikSearchObject, Model.Requests.KorisnikInsertRequest, Model.Requests.KorisnikUpdateRequest>
    {
        public KorisniciController(ILogger<BaseController<Korisnik, Model.SearchObject.KorisnikSearchObject>> logger, IKorisniciService service) : base(logger, service)
        {

        }
    }
}
