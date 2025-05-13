using Microsoft.AspNetCore.Mvc;
using eSpa.Model;
using eSpa.Model.SearchObject;
using eSpa.Service;
using eSpa.Model.Requests;
using Microsoft.AspNetCore.Authorization;
using System.Data;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UslugaController : BaseCRUDController<Model.Usluga,Model.SearchObject.UslugaSearchObject,Model.Requests.UslugaInsertRequest,Model.Requests.UslugaUpdateRequest>
    {
       /* public IActionResult Index()
        {
            return View();
        }*/

        private readonly IUslugaService _uslugaService;
       public UslugaController(ILogger<BaseController<Usluga,UslugaSearchObject>>logger, IUslugaService service) : base(logger, service)
        {
            _uslugaService = service;
        }
        [Authorize(Roles = "Administrator")]
        public override Task<Usluga> Insert([FromBody] UslugaInsertRequest insert)
        {
            return base.Insert(insert);
        }
        // Update metoda
        [Authorize(Roles = "Administrator")]
        public override Task<Usluga> Update(int id, [FromBody] UslugaUpdateRequest update)
        {
            return base.Update(id, update);
        }

        // Delete metoda
        [Authorize(Roles = "Administrator")]
        public override Task<bool> Delete(int id)
        {
            return base.Delete(id);
        }

        [Authorize]
        [HttpGet("RezervacijePoUslugama")]
        public async Task<IActionResult> GetRezervacijePoUslugama()
        {
            var data = await _uslugaService.GetRezervacijePoUslugama();
            return Ok(data); // Vraćamo podatke u odgovoru
        }


        [HttpGet("recommend/{uslugaId}/{korisnikId}")]
        public IActionResult GetRecommendations(int uslugaId, int korisnikId)
        {
            // Pozivamo Recommend metodu iz usluga servisa
            List<Model.Usluga> recommendations = _uslugaService.Recommend(uslugaId, korisnikId);

            if (recommendations != null && recommendations.Count > 0)
            {
                return Ok(recommendations);  // Vraćamo preporučene usluge
            }
            else
            {
                return NotFound("No recommendations found");  // Ako nema preporuka
            }
        }

    }
}
