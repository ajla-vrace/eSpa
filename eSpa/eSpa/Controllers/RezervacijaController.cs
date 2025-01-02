using eSpa.Model;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service;
using Microsoft.AspNetCore.Mvc;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RezervacijaController : BaseCRUDController<Model.Rezervacija,RezervacijaSearchObject,RezervacijaInsertRequest,RezervacijaUpdateRequest>
    {
        public RezervacijaController(ILogger<BaseController<Rezervacija, RezervacijaSearchObject>> logger, IRezervacijaService service) : base(logger, service)
        {

        }
    }
}
