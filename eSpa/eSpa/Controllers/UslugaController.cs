using Microsoft.AspNetCore.Mvc;
using eSpa.Model;
using eSpa.Model.SearchObject;
using eSpa.Service;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UslugaController : BaseCRUDController<Model.Usluga,Model.SearchObject.UslugaSearchObject,Model.Requests.UslugaInsertRequest,Model.Requests.UslugaUpdateRequest>
    {
       /* public IActionResult Index()
        {
            return View();
        }*/
       public UslugaController(ILogger<BaseController<Usluga,UslugaSearchObject>>logger, IUslugaService service) : base(logger, service)
        {

        }
    }
}
