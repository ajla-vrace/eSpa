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
    public class ZaposlenikRecenzijaController : BaseCRUDController<Model.ZaposlenikRecenzija, ZaposlenikRecenzijaSearchObject, ZaposlenikRecenzijaInsertRequest, ZaposlenikRecenzijaUpdateRequest>
    {
        public ZaposlenikRecenzijaController(ILogger<BaseController<ZaposlenikRecenzija, ZaposlenikRecenzijaSearchObject>> logger, IZaposlenikRecenzijaService service) : base(logger, service)
        {

        }
        [Authorize]
        public override Task<ZaposlenikRecenzija> Insert([FromBody] ZaposlenikRecenzijaInsertRequest insert)
        {
            return base.Insert(insert);
        }
        // Update metoda
        [Authorize]
        public override Task<ZaposlenikRecenzija> Update(int id, [FromBody] ZaposlenikRecenzijaUpdateRequest update)
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
