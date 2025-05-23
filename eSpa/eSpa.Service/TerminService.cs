﻿using AutoMapper;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Linq;

namespace eSpa.Service
{
    public class TerminService:BaseCRUDService<Model.Termin,Database.Termin,TerminSearchObject,TerminInsertRequest,TerminUpdateRequest>,ITerminService
    {
        public TerminService(IB200069Context context, IMapper mapper) : base(context, mapper)
        {

        }

        /*public override IQueryable<Database.Termin> AddFilter(IQueryable<Database.Termin> query, TerminSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                filteredQuery = filteredQuery.Where(x => x.Naziv.Contains(search.FTS));
            }



            return filteredQuery;
        }
        *//*
        public override IQueryable<Database.Termin> AddFilter(IQueryable<Database.Termin> query, TerminSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            // Filtriraj po vremenu početka ako je vrednost za Pocetak prosleđena
            if (search?.Pocetak.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.Pocetak == search.Pocetak);
            }

            return filteredQuery;
        }*/     //prikazivalo error



        public override IQueryable<Database.Termin> AddFilter(IQueryable<Database.Termin> query, TerminSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Pocetak))
            {
                // Validiraj i konvertuj Pocetak iz string formata u TimeSpan
                if (TimeSpan.TryParseExact(search.Pocetak, "hh\\:mm", null, out TimeSpan pocetak))
                {
                    filteredQuery = filteredQuery.Where(x => x.Pocetak == pocetak);
                }
                else
                {
                    throw new ArgumentException("Pogrešan format za Pocetak. Koristi format HH:mm (npr. 09:00).");
                }
            }

            return filteredQuery;
        }
        




        /* public override Task<Model.Termin> Insert(TerminInsertRequest insert)
         {

             return base.Insert(insert);

         }*/ //ovo je ispravljeno ispod

        public override Task<Model.Termin> Insert(TerminInsertRequest insert)
        {
            // Validacija unosa i konverzija
            if (TimeSpan.TryParseExact(insert.Pocetak, "hh\\:mm", null, out TimeSpan pocetak))
            {
                insert.Pocetak = pocetak.ToString(@"hh\:mm"); // Čuvanje kao string
            }
            else
            {
                throw new ArgumentException("Pogrešan format za Pocetak. Koristi format HH:mm (npr. 09:00).");
            }

            if (TimeSpan.TryParseExact(insert.Kraj, "hh\\:mm", null, out TimeSpan kraj))
            {
                insert.Kraj = kraj.ToString(@"hh\:mm"); // Čuvanje kao string
            }
            else
            {
                throw new ArgumentException("Pogrešan format za Kraj. Koristi format HH:mm (npr. 09:30).");
            }
            var exists = _context.Termins
         .Any(x => x.Pocetak == pocetak && x.Kraj == kraj);

            if (exists)
            {
                throw new ArgumentException("Termin sa istim vremenskim intervalom već postoji.");
            }

            return base.Insert(insert);
        }


        public override async Task<Model.Termin> Update(int id, TerminUpdateRequest update)
        {
            var entity = await _context.Termins.FindAsync(id);

            return await base.Update(id, update);
        }
        public override async Task<bool> Delete(int id)
        {
            var termin = await _context.Termins.FindAsync(id);

            if (termin == null)
                return false;

            // 1. Nađi rezervacije koje imaju ovaj termin
            var rezervacije = await _context.Rezervacijas
                .Where(r => r.TerminId == id)
                .ToListAsync();

            if (rezervacije.Any())
                _context.Rezervacijas.RemoveRange(rezervacije);

            // 2. Obriši termin
            _context.Termins.Remove(termin);

            await _context.SaveChangesAsync();

            return true;
        }

    }
}
