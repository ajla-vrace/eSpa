using eSpa.Model;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service;
using Microsoft.AspNetCore.Mvc;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class OcjenaController : BaseCRUDController<Model.Ocjena,OcjenaSearchObject,OcjenaInsertRequest,OcjenaUpdateRequest>
    {
        public OcjenaController(ILogger<BaseController<Ocjena, OcjenaSearchObject>> logger, IOcjenaService service) : base(logger, service)
        {

        }
    }
}
