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
    public class RezervacijaService:BaseCRUDService<Model.Rezervacija,Database.Rezervacija,RezervacijaSearchObject,RezervacijaInsertRequest,RezervacijaUpdateRequest>,IRezervacijaService
    {
        public RezervacijaService(eSpaContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.Rezervacija> AddFilter(IQueryable<Database.Rezervacija> query, RezervacijaSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                filteredQuery = filteredQuery.Where(x => x.Status.Contains(search.FTS));
            }



            return filteredQuery;
        }

        /*public override Task<Model.Rezervacija> Insert(RezervacijaInsertRequest insert)
        {

            return base.Insert(insert);
        }*/
        public override async Task<Model.Rezervacija> Insert(RezervacijaInsertRequest insert)
        {
            // Mapiraj unos u entitet
            var entity = _mapper.Map<Database.Rezervacija>(insert);

            // Postavi podrazumevani status ako nije prosleđen
            entity.Status = "Aktivna";

            // Dodaj entitet u kontekst i sačuvaj promene
            _context.Set<Database.Rezervacija>().Add(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Rezervacija>(entity);
        }


        /*public override async Task<Model.Rezervacija> Update(int id, RezervacijaUpdateRequest update)
        {
            var entity = await _context.Rezervacijas.FindAsync(id);

            return await base.Update(id, update);
        }*/

    }
}
