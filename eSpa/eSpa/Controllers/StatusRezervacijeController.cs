using eSpa.Model.SearchObject;
using eSpa.Service;
using Microsoft.AspNetCore.Mvc;

namespace eSpa.Controllers
{

    [ApiController]
    [Route("[controller]")]
    public class StatusRezervacijeController : BaseController<Model.StatusRezervacije,StatusRezervacijeSearchObject>
    {
        public StatusRezervacijeController(ILogger<BaseController<Model.StatusRezervacije, StatusRezervacijeSearchObject>> logger, IStatusRezervacijeService service) : base(logger, service)
        {

        }
    }
}
