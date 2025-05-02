using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Model;
using eSpa.Service;
using Microsoft.AspNetCore.Mvc;
namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ZaposlenikRecenzijaController : BaseCRUDController<Model.ZaposlenikRecenzija, ZaposlenikRecenzijaSearchObject, ZaposlenikRecenzijaInsertRequest, ZaposlenikRecenzijaUpdateRequest>
    {
        public ZaposlenikRecenzijaController(ILogger<BaseController<ZaposlenikRecenzija, ZaposlenikRecenzijaSearchObject>> logger, IZaposlenikRecenzijaService service) : base(logger, service)
        {

        }
    }
}
