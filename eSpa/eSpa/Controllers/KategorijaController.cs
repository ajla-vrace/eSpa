using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service;
//using eSpa.Service.Database;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eSpa.Controllers
{
    //[ApiController]
    //[Route("api/[controller]")]
    [ApiController]
    [AllowAnonymous]
    public class KategorijaController : BaseController<Model.Kategorija,KategorijaSearchObject>
    {
        //private readonly IKategorijaService _service;
        //private readonly ILogger _logger;
        public KategorijaController(ILogger<BaseController<Model.Kategorija,KategorijaSearchObject>> logger, IKategorijaService service):base(logger,service)
        {
           /* _service = kategorijaService;
            _logger = logger;*/
        }
        //ovo sada ne treba jer se nasljedio basecontroller
       /* [HttpGet()]
        public async Task<IEnumerable<Model.Kategorija>> Get()
        {
            return await _service.Get();
        }*/
        /*
        [HttpPost]
        public Model.Kategorija Insert(KategorijaInsertRequest request)
        {
            return _service.Insert(request);
        }
        [HttpPut]
        public Model.Kategorija Update(int id, KategorijaUpdateRequest request)
        {
            return _service.Update(id,request);
        }*/

        /* [HttpGet]
         public async Task<ActionResult<IEnumerable<Kategorija>>> GetAll()
         {
             var kategorije = await _kategorijaService.GetAll();
             return Ok(kategorije);
         }

         [HttpGet("{id}")]
         public async Task<ActionResult<Kategorija>> GetById(int id)
         {
             var kategorija = await _kategorijaService.GetById(id);
             if (kategorija == null) return NotFound();
             return Ok(kategorija);
         }

         [HttpPost]
         public async Task<ActionResult<Kategorija>> AddKategorija(Kategorija novaKategorija)
         {
             var createdKategorija = await _kategorijaService.AddKategorija(novaKategorija);
             return CreatedAtAction(nameof(GetById), new { id = createdKategorija.Id }, createdKategorija);
         }

         [HttpPut("{id}")]
         public async Task<ActionResult<Kategorija>> UpdateKategorija(int id, Kategorija kategorija)
         {
             var updatedKategorija = await _kategorijaService.UpdateKategorija(id, kategorija);
             if (updatedKategorija == null) return NotFound();
             return Ok(updatedKategorija);
         }

         [HttpDelete("{id}")]
         public async Task<IActionResult> DeleteKategorija(int id)
         {
             var success = await _kategorijaService.DeleteKategorija(id);
             if (!success) return NotFound();
             return NoContent();
         }*/
    }

}
