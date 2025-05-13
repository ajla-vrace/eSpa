using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Model;
using eSpa.Service;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using System.Data;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class NovostInterakcijaController : BaseCRUDController<Model.NovostInterakcija, NovostInterakcijaSearchObject, NovostInterakcijaInsertRequest, NovostInterakcijaUpdateRequest>
    {
        public NovostInterakcijaController(ILogger<BaseController<NovostInterakcija, NovostInterakcijaSearchObject>> logger, INovostInterakcijaService service) : base(logger, service)
        {

        }
        [Authorize]
        public override Task<NovostInterakcija> Insert([FromBody] NovostInterakcijaInsertRequest insert)
        {
            return base.Insert(insert);
        }
        // Update metoda
        [Authorize]
        public override Task<NovostInterakcija> Update(int id, [FromBody] NovostInterakcijaUpdateRequest update)
        {
            return base.Update(id, update);
        }

        // Delete metoda
        [Authorize]
        public override Task<bool> Delete(int id)
        {
            return base.Delete(id);
        }
    }
}
