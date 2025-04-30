using eSpa.Service;
using eSpa.Model;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using eSpa.Model.Requests;

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

    }
}
