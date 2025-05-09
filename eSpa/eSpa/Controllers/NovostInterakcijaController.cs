using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Model;
using eSpa.Service;
using Microsoft.AspNetCore.Mvc;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class NovostInterakcijaController : BaseCRUDController<Model.NovostInterakcija, NovostInterakcijaSearchObject, NovostInterakcijaInsertRequest, NovostInterakcijaUpdateRequest>
    {
        public NovostInterakcijaController(ILogger<BaseController<NovostInterakcija, NovostInterakcijaSearchObject>> logger, INovostInterakcijaService service) : base(logger, service)
        {

        }
    }
}
