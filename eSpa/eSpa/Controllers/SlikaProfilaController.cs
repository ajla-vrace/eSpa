using eSpa.Model;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service;
using Microsoft.AspNetCore.Mvc;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class SlikaProfilaController : BaseCRUDController<Model.SlikaProfila, SlikaProfilaSearchObject, SlikaProfilaInsertRequest, SlikaProfilaUpdateRequest>
    {
        public SlikaProfilaController(ILogger<BaseController<SlikaProfila, SlikaProfilaSearchObject>> logger, ISlikaProfilaService service) : base(logger, service)
        {

        }

    }
}
