using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Model;
using eSpa.Service;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using Microsoft.AspNetCore.Authorization;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class NovostKomentarController : BaseCRUDController<Model.NovostKomentar, NovostKomentarSearchObject, NovostKomentarInsertRequest, NovostKomentarUpdateRequest>
    {
        public NovostKomentarController(ILogger<BaseController<NovostKomentar, NovostKomentarSearchObject>> logger, INovostKomentarService service) : base(logger, service)
        {

        }
        [Authorize]
        public override Task<NovostKomentar> Insert([FromBody] NovostKomentarInsertRequest insert)
        {
            return base.Insert(insert);
        }
        // Update metoda
        [Authorize]
        public override Task<NovostKomentar> Update(int id, [FromBody] NovostKomentarUpdateRequest update)
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
