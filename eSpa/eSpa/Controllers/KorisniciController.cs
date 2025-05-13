using eSpa.Service;
using eSpa.Model;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using eSpa.Model.Requests;
using Microsoft.AspNetCore.Authorization;
using System.Data;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KorisniciController : BaseCRUDController<Model.Korisnik, Model.SearchObject.KorisnikSearchObject, Model.Requests.KorisnikInsertRequest, Model.Requests.KorisnikUpdateRequest>
    {
        private readonly IKorisniciService _korisniciService;

        public KorisniciController(ILogger<BaseController<Korisnik, Model.SearchObject.KorisnikSearchObject>> logger, IKorisniciService service) : base(logger, service)
        {
            _korisniciService = service;
        }
        [Authorize(Roles = "Administrator")]
        public override Task<Korisnik> Insert([FromBody] KorisnikInsertRequest insert)
        {
            return base.Insert(insert);
        }
        // Update metoda
        [Authorize]
        public override Task<Korisnik> Update(int id, [FromBody] KorisnikUpdateRequest update)
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
        [HttpPost("ChangePassword")]
        public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordRequest model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    var userId = model.Id; // Pretpostavljam da korisnik već ima ID u tokenu
                    await _korisniciService.ChangePasswordAsync(model);
                    return Ok(new { message = "Password changed successfully" });
                }
                catch (Exception ex)
                {
                    return BadRequest(new { message = ex.Message });
                }
            }
            return BadRequest("Invalid request");
        }
        [HttpPut("Blokiraj/{id}")]
        public async Task<IActionResult> BlokirajKorisnika(int id)
        {
            try
            {
                await _korisniciService.BlokirajKorisnika(id);
                return Ok(); // ili return NoContent();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }



    }
}
