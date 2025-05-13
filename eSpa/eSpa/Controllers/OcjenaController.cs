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
    public class OcjenaController : BaseCRUDController<Model.Ocjena,OcjenaSearchObject,OcjenaInsertRequest,OcjenaUpdateRequest>
    {
        private readonly IOcjenaService _ocjenaService;
        public OcjenaController(ILogger<BaseController<Ocjena, OcjenaSearchObject>> logger, IOcjenaService service) : base(logger, service)
        {
            _ocjenaService = service;
        }

        [Authorize]
        public override Task<Ocjena> Insert([FromBody] OcjenaInsertRequest insert)
        {
            return base.Insert(insert);
        }
        // Update metoda
        [Authorize]
        public override Task<Ocjena> Update(int id, [FromBody] OcjenaUpdateRequest update)
        {
            return base.Update(id, update);
        }

        // Delete metoda
        [Authorize]
        public override Task<bool> Delete(int id)
        {
            return base.Delete(id);
        }




        [Authorize]
        [HttpGet("UslugeProsjecneOcjene")]
        public async Task<IActionResult> GetUslugeProsjecneOcjene()
        {
            var data = await _ocjenaService.GetUslugeProsjecneOcjene();
            return Ok(data); // Vraćamo podatke u odgovoru
        }

    }
}
