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

            if (!string.IsNullOrWhiteSpace(search?.Korisnik))
            {
                filteredQuery = filteredQuery.Where(x => x.Korisnik.KorisnickoIme.Contains(search.Korisnik));
            }
            if (!string.IsNullOrWhiteSpace(search?.Usluga))
            {
                filteredQuery = filteredQuery.Where(x => x.Usluga.Naziv.Contains(search.Usluga));
            }
            if (!string.IsNullOrWhiteSpace(search?.Status))
            {
                filteredQuery = filteredQuery.Where(x => x.Status.Contains(search.Status));
            }


            filteredQuery = filteredQuery.Include(x => x.Korisnik)
                .Include(x => x.Usluga).ThenInclude(x=>x.Kategorija)
                .Include(x => x.Termin);

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
            if (entity == null)
            {
                throw new KeyNotFoundException("Rezervacija nije pronađena.");
            }

            _mapper.Map(update, entity);
            //entity.DatumKreiranja = DateTime.Now;

            _context.Rezervacijas.Update(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Rezervacija>(entity);
        }
        */
        public override async Task<Model.Rezervacija> Update(int id, RezervacijaUpdateRequest update)
        {
            var entity = await _context.Rezervacijas.FindAsync(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("Rezervacija nije pronađena.");
            }

            // Uzmi TerminId iz entiteta i pronađi odgovarajući termin
            var termin = await _context.Termins.FindAsync(entity.TerminId);
            if (termin == null)
            {
                throw new KeyNotFoundException("Termin nije pronađen.");
            }

            // Sada možeš koristiti podatke o terminu
            var terminDatum = entity.Datum.Add(termin.Pocetak); // Pretpostavljamo da je Datum u entity-ju datum, a Pocetak je time u Terminu

            // Proveri da li je moguće promeniti status u 'Otkazana' na temelju trenutnog vremena
            if (terminDatum < DateTime.Now)
            {
                throw new InvalidOperationException("Termin je već prošao i ne može se otkazati.");
            }

            _mapper.Map(update, entity);
            _context.Rezervacijas.Update(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Rezervacija>(entity);
        }



    }
}
