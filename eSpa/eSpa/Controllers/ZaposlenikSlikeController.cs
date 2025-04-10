using eSpa.Model;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service;
using Microsoft.AspNetCore.Mvc;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ZaposlenikSlikeController : BaseCRUDController<Model.ZaposlenikSlike, ZaposlenikSlikeSearchObject, ZaposlenikSlikeInsertRequest, ZaposlenikSlikeUpdateRequest>
    {
        public ZaposlenikSlikeController(ILogger<BaseController<ZaposlenikSlike, ZaposlenikSlikeSearchObject>> logger, IZaposlenikSlikeService service) : base(logger, service)
        {

        }

    }
}
