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
    public class RezervacijaController : BaseCRUDController<Model.Rezervacija,RezervacijaSearchObject,RezervacijaInsertRequest,RezervacijaUpdateRequest>
    {
        public RezervacijaController(ILogger<BaseController<Rezervacija, RezervacijaSearchObject>> logger, IRezervacijaService service) : base(logger, service)
        {

        }
        [Authorize]
        public override Task<Rezervacija> Insert([FromBody] RezervacijaInsertRequest insert)
        {
            return base.Insert(insert);
        }
        // Update metoda
        [Authorize]
        public override Task<Rezervacija> Update(int id, [FromBody] RezervacijaUpdateRequest update)
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
