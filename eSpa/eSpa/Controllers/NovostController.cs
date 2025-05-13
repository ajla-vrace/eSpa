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
    public class NovostController : BaseCRUDController<Model.Novost,NovostSearchObject,NovostInsertRequest,NovostUpdateRequest>
    {
        public NovostController(ILogger<BaseController<Novost, NovostSearchObject>> logger, INovostService service) : base(logger, service)
        {

        }
        [Authorize(Roles = "Administrator")]
        public override Task<Novost> Insert([FromBody] NovostInsertRequest insert)
        {
            return base.Insert(insert);
        }
        // Update metoda
        [Authorize(Roles = "Administrator")]
        public override Task<Novost> Update(int id, [FromBody] NovostUpdateRequest update)
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
