using eSpa.Model;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service;
using Microsoft.AspNetCore.Mvc;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class NovostController : BaseCRUDController<Model.Novost,NovostSearchObject,NovostInsertRequest,NovostUpdateRequest>
    {
        public NovostController(ILogger<BaseController<Novost, NovostSearchObject>> logger, INovostService service) : base(logger, service)
        {

        }

    }
}
