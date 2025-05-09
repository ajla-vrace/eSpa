using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Model;
using eSpa.Service;
using Microsoft.AspNetCore.Mvc;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class FavoritController : BaseCRUDController<Model.Favorit, FavoritSearchObject, FavoritInsertRequest, FavoritUpdateRequest>
    {
        public FavoritController(ILogger<BaseController<Favorit, FavoritSearchObject>> logger, IFavoritService service) : base(logger, service)
        {

        }
    }
}
