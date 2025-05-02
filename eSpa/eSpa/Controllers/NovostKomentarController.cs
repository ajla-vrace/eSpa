using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Model;
using eSpa.Service;
using Microsoft.AspNetCore.Mvc;


namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class NovostKomentarController : BaseCRUDController<Model.NovostKomentar, NovostKomentarSearchObject, NovostKomentarInsertRequest, NovostKomentarUpdateRequest>
    {
        public NovostKomentarController(ILogger<BaseController<NovostKomentar, NovostKomentarSearchObject>> logger, INovostKomentarService service) : base(logger, service)
        {

        }
    }
}
