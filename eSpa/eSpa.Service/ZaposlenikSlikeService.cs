using AutoMapper;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service.Database;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Service
{
    public class ZaposlenikSlikeService : BaseCRUDService<Model.ZaposlenikSlike, Database.ZaposlenikSlike, ZaposlenikSlikeSearchObject, ZaposlenikSlikeInsertRequest, ZaposlenikSlikeUpdateRequest>, IZaposlenikSlikeService
    {
        public ZaposlenikSlikeService(eSpaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override async Task<Model.ZaposlenikSlike> Insert(ZaposlenikSlikeInsertRequest insert)
        {
            var entity = new Database.ZaposlenikSlike
            {
                //ZaposlenikId = insert.ZaposlenikId,
                Naziv = insert.Naziv,
                Slika = Convert.FromBase64String(insert.SlikaBase64), // Konvertovanje Base64 u byte[]
                Tip = insert.Tip,
                DatumPostavljanja = DateTime.Now
            };

            _context.ZaposlenikSlikes.Add(entity);
            await _context.SaveChangesAsync(); // Asinhrono čuvanje u bazi

            return _mapper.Map<Model.ZaposlenikSlike>(entity);
        }


       /* public List<ZaposlenikSlike> GetByZaposlenikId(int zaposlenikId)
        {
            var slike = _context.ZaposlenikSlikes
                .Where(x => x.ZaposlenikId == zaposlenikId)
                .ToList();

            return _mapper.Map<List<Model.ZaposlenikSlike>>(slike);
        }
    */
}
}
