using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Model;
using eSpa.Service;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using System.Data;

namespace eSpa.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class FavoritController : BaseCRUDController<Model.Favorit, FavoritSearchObject, FavoritInsertRequest, FavoritUpdateRequest>
    {
        IFavoritService _service;
        public FavoritController(ILogger<BaseController<Favorit, FavoritSearchObject>> logger, IFavoritService service) : base(logger, service)
        {
            _service = service;
        }
        [Authorize]
        public override Task<Favorit> Insert([FromBody] FavoritInsertRequest insert)
        {
            return base.Insert(insert);
        }
        // Update metoda
        [Authorize]
        public override Task<Favorit> Update(int id, [FromBody] FavoritUpdateRequest update)
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
