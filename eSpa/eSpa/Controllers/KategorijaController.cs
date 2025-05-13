using eSpa.Model;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service;
//using eSpa.Service.Database;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KategorijaController : BaseCRUDController<Model.Kategorija, KategorijaSearchObject, KategorijaInsertRequest, KategorijaUpdateRequest>
    {
        public KategorijaController(ILogger<BaseController<Kategorija, KategorijaSearchObject>> logger, IKategorijaService service) : base(logger, service)
        {

        }
        [Authorize(Roles = "Administrator")]
        public override Task<Kategorija> Insert([FromBody] KategorijaInsertRequest insert)
        {
            return base.Insert(insert);
        }
        // Update metoda
        [Authorize(Roles = "Administrator")]
        public override Task<Kategorija> Update(int id, [FromBody] KategorijaUpdateRequest update)
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
