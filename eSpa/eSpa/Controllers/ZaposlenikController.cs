using eSpa.Model;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service;
using Microsoft.AspNetCore.Mvc;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ZaposlenikController : BaseCRUDController<Model.Zaposlenik, ZaposlenikSearchObject, ZaposlenikInsertRequest, ZaposlenikUpdateRequest>
    {
        public ZaposlenikController(ILogger<BaseController<Zaposlenik, ZaposlenikSearchObject>> logger, IZaposlenikService service) : base(logger, service)
        {

        }
    }
}
