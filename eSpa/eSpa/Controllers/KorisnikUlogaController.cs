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
    public class KorisnikUlogaController : BaseCRUDController<Model.KorisnikUloga, KorisnikUlogaSearchObject, KorisnikUlogaInsertRequest, KorisnikUlogaUpdateRequest>
    {
        public KorisnikUlogaController(ILogger<BaseController<Model.KorisnikUloga, KorisnikUlogaSearchObject>> logger, IKorisnikUlogaService service) : base(logger, service)
        {

        }
        [Authorize(Roles = "Administrator")]
        public override Task<KorisnikUloga> Insert([FromBody] KorisnikUlogaInsertRequest insert)
        {
            return base.Insert(insert);
        }
        // Update metoda
        [Authorize(Roles = "Administrator")]
        public override Task<KorisnikUloga> Update(int id, [FromBody] KorisnikUlogaUpdateRequest update)
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
