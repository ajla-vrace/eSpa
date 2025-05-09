using AutoMapper;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Service
{
    public class SlikaProfilaService : BaseCRUDService<Model.SlikaProfila, Database.SlikaProfila, SlikaProfilaSearchObject, SlikaProfilaInsertRequest, SlikaProfilaUpdateRequest>, ISlikaProfilaService
    {
        public SlikaProfilaService(eSpaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override async Task<Model.SlikaProfila> Insert(SlikaProfilaInsertRequest insert)
        {
            var entity = new Database.SlikaProfila
            {
                //ZaposlenikId = insert.ZaposlenikId,
                Naziv = insert.Naziv,
                Slika = Convert.FromBase64String(insert.SlikaBase64), // Konvertovanje Base64 u byte[]
                Tip = insert.Tip,
                DatumPostavljanja = DateTime.Now
            };

            _context.SlikaProfilas.Add(entity);
            await _context.SaveChangesAsync(); // Asinhrono čuvanje u bazi

            return _mapper.Map<Model.SlikaProfila>(entity);
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
