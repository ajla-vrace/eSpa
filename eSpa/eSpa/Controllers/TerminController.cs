using eSpa.Model;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Data;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TerminController : BaseCRUDController<Model.Termin,TerminSearchObject,TerminInsertRequest,TerminUpdateRequest>
    {
        public TerminController(ILogger<BaseController<Termin, TerminSearchObject>> logger, ITerminService service) : base(logger, service)
        {

        }
        [Authorize(Roles = "Administrator")]
        public override Task<Termin> Insert([FromBody] TerminInsertRequest insert)
        {
            return base.Insert(insert);
        }
        // Update metoda
        [Authorize(Roles = "Administrator")]
        public override Task<Termin> Update(int id, [FromBody] TerminUpdateRequest update)
        {
            return base.Update(id, update);
        }

        // Delete metoda
        [Authorize(Roles = "Administrator")]
        public override Task<bool> Delete(int id)
        {
            return base.Delete(id);
        }
    }
}

