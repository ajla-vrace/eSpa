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
    public class UlogaController : BaseCRUDController<Model.Uloga, UlogaSearchObject, UlogaInsertRequest, UlogaUpdateRequest>
    {
        public UlogaController(ILogger<BaseController<Model.Uloga, UlogaSearchObject>> logger, IUlogaService service) : base(logger, service)
        {

        }
        [Authorize(Roles = "Administrator")]
        public override Task<Uloga> Insert([FromBody] UlogaInsertRequest insert)
        {
            return base.Insert(insert);
        }
        // Update metoda
        [Authorize(Roles = "Administrator")]
        public override Task<Uloga> Update(int id, [FromBody] UlogaUpdateRequest update)
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
