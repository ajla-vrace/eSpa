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
    public class ZaposlenikController : BaseCRUDController<Model.Zaposlenik, ZaposlenikSearchObject, ZaposlenikInsertRequest, ZaposlenikUpdateRequest>
    {
        public ZaposlenikController(ILogger<BaseController<Zaposlenik, ZaposlenikSearchObject>> logger, IZaposlenikService service) : base(logger, service)
        {

        }
        [Authorize(Roles = "Administrator")]
        public override Task<Zaposlenik> Insert([FromBody] ZaposlenikInsertRequest insert)
        {
            return base.Insert(insert);
        }
        // Update metoda
        [Authorize(Roles = "Administrator")]
        public override Task<Zaposlenik> Update(int id, [FromBody] ZaposlenikUpdateRequest update)
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
