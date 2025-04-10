using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service;
using Microsoft.AspNetCore.Mvc;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UlogaController : BaseCRUDController<Model.Uloga, UlogaSearchObject, UlogaInsertRequest, UlogaUpdateRequest>
    {
        public UlogaController(ILogger<BaseController<Model.Uloga, UlogaSearchObject>> logger, IUlogaService service) : base(logger, service)
        {

        }

    }
}
