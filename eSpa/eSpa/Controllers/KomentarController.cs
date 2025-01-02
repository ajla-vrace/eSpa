using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Model;
using eSpa.Service;
using Microsoft.AspNetCore.Mvc;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KomentarController : BaseCRUDController<Model.Komentar,KomentarSearchObject,KomentarInsertRequest,KomentarUpdateRequest>
    {
        public KomentarController(ILogger<BaseController<Komentar,KomentarSearchObject>> logger, IKomentarService service) : base(logger, service)
        {

        }
    }
}
