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
    public class KomentarController : BaseCRUDController<Model.Komentar,KomentarSearchObject,KomentarInsertRequest,KomentarUpdateRequest>
    {
        public KomentarController(ILogger<BaseController<Komentar,KomentarSearchObject>> logger, IKomentarService service) : base(logger, service)
        {

        }
        [Authorize]
        public override Task<Komentar> Insert([FromBody] KomentarInsertRequest insert)
        {
            return base.Insert(insert);
        }
        // Update metoda
        [Authorize]
        public override Task<Komentar> Update(int id, [FromBody] KomentarUpdateRequest update)
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
