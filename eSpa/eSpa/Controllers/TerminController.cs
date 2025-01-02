using eSpa.Model;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service;
using Microsoft.AspNetCore.Mvc;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TerminController : BaseCRUDController<Model.Termin,TerminSearchObject,TerminInsertRequest,TerminUpdateRequest>
    {
        public TerminController(ILogger<BaseController<Termin, TerminSearchObject>> logger, ITerminService service) : base(logger, service)
        {

        }
    }
}

