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
using RabbitMQ.Client;
using System.Text;
using System.Text.Json;

namespace eSpa.Service
{
    public class ZaposlenikService : BaseCRUDService<Model.Zaposlenik, Database.Zaposlenik, ZaposlenikSearchObject, ZaposlenikInsertRequest, ZaposlenikUpdateRequest>, IZaposlenikService
    {
        public ZaposlenikService(IB200069Context context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.Zaposlenik> AddFilter(IQueryable<Database.Zaposlenik> query, ZaposlenikSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Ime))
            {
                filteredQuery = filteredQuery.Where(x => x.Korisnik.Ime.Contains(search.Ime));
            }
            if (!string.IsNullOrWhiteSpace(search?.Prezime))
            {
                filteredQuery = filteredQuery.Where(x => x.Korisnik.Prezime.Contains(search.Prezime));
            }
            if (!string.IsNullOrWhiteSpace(search?.KorisnickoIme))
            {
                filteredQuery = filteredQuery.Where(x => x.Korisnik.KorisnickoIme.Contains(search.KorisnickoIme));
            }
            if (!string.IsNullOrWhiteSpace(search?.Status))
            {
                filteredQuery = filteredQuery.Where(x => x.Status==(search.Status));
            }
            if (!string.IsNullOrWhiteSpace(search?.Uloga))
            {
                filteredQuery = filteredQuery.Where(x =>
                    x.Korisnik.KorisnikUlogas.Any(ku => ku.Uloga.Naziv.Contains(search.Uloga))
                );
            }
            if (!string.IsNullOrWhiteSpace(search?.Kategorija))
            {
                filteredQuery = filteredQuery.Where(x => x.Kategorija.Naziv==(search.Kategorija));
            }

            // filteredQuery = filteredQuery.Include(x => x.Korisnik); //dodano
            /*filteredQuery = filteredQuery
                    .Include(x => x.Korisnik)
                        .Include(x => x.Slika);*/
            filteredQuery = filteredQuery
     .Include(x => x.Korisnik)
         .ThenInclude(k => k.KorisnikUlogas)
             .ThenInclude(ku => ku.Uloga)
     .Include(x => x.Korisnik)
         .ThenInclude(k => k.Slika)
     .Include(x => x.Kategorija); // ⬅️ Ovo dodaje Kategoriju




            return filteredQuery;
        }

        /*public async override Task<Model.Zaposlenik> Insert(ZaposlenikInsertRequest insert)
        {

            var entity = _mapper.Map<Database.Zaposlenik>(insert);

            //entity.DatumZaposlenja = DateTime.Now;
            _context.Zaposleniks.Add(entity);
            await _context.SaveChangesAsync();


            return _mapper.Map<Model.Zaposlenik>(entity);
        }*/
        public async override Task<Model.Zaposlenik> Insert(ZaposlenikInsertRequest insert)
        {
            // Mapiraj ZaposlenikInsertRequest u entitet Zaposlenik
            var entity = _mapper.Map<Database.Zaposlenik>(insert);

            // Pronađi ulogu terapeut (pretpostavljamo da ID za terapeut je 2)
            var uloga = await _context.Ulogas.FindAsync(2);  // Ovdje možete koristiti ID 2 za ulogu terapeut
            if (uloga == null)
            {
                throw new KeyNotFoundException("Uloga 'Terapeut' nije pronađena.");
            }
            //entity.Korisnik.IsZaposlenik = true;
            // Dodaj zaposlenika
            _context.Zaposleniks.Add(entity);
            await _context.SaveChangesAsync();

            var korisnik = await _context.Korisniks.FindAsync(entity.KorisnikId);
            if (korisnik == null)
            {
                throw new KeyNotFoundException("Korisnik nije pronađen.");
            }
            korisnik.IsZaposlenik = true;
            _context.Korisniks.Update(korisnik);
            await _context.SaveChangesAsync();


            // Dodaj ulogu terapeut zaposleniku
            var zaposlenikUloga = new Database.KorisnikUloga
            {
                KorisnikId = entity.KorisnikId,  // ID zaposlenika
                UlogaId = uloga.Id       // ID uloge terapeut
            };

            // Dodaj ulogu u odgovarajuću tabelu (pretpostavljamo da postoji KorisnikUloga tabela)
            _context.KorisnikUlogas.Add(zaposlenikUloga);
            await _context.SaveChangesAsync();

            // Mapiraj i vrati model
            return _mapper.Map<Model.Zaposlenik>(entity);
        }


        /* public override async Task<Model.Zaposlenik> Update(int id, ZaposlenikUpdateRequest update)
         {
             var entity = await _context.Zaposleniks.FindAsync(id);
             if (entity == null)
             {
                 throw new KeyNotFoundException("Zaposlenik nije pronađen.");
             }

             _mapper.Map(update, entity);
             //entity.DatumZaposlenja = DateTime.Now;

             _context.Zaposleniks.Update(entity);
             await _context.SaveChangesAsync();

             return _mapper.Map<Model.Zaposlenik>(entity);
         }*/


        /*
        public override async Task<Model.Zaposlenik> Update(int id, ZaposlenikUpdateRequest update)
        {
            var entity = await _context.Zaposleniks.FindAsync(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("Zaposlenik nije pronađen.");
            }

            // Mapiraj sve ostale podatke
            _mapper.Map(update, entity);

            // Ako je poslano novo SlikaId, ažuriraj ga
            if (update.SlikaId.HasValue && update.SlikaId != entity.SlikaId)
            {
                // Ako već postoji stara slika, brišemo vezu prema njoj (ali ne brišemo sliku iz baze)
                if (entity.SlikaId.HasValue)
                {
                    entity.SlikaId = null;
                }

                // Dodaj novu vezu prema slici
                entity.SlikaId = update.SlikaId;
            }

            // Spasi promjene
            _context.Zaposleniks.Update(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Zaposlenik>(entity);
        }
        */


        public override async Task<Model.Zaposlenik> Update(int id, ZaposlenikUpdateRequest update)
        {
            /* var entity = await _context.Zaposleniks
                 .FindAsync(id);*/
            var entity = await _context.Zaposleniks
                        .Include(z => z.Korisnik)
                    .FirstOrDefaultAsync(z => z.Id == id);

            if (entity == null)
            {
                throw new KeyNotFoundException("Zaposlenik nije pronađen.");
            }

            // Mapiraj ostale podatke

            if (!string.IsNullOrWhiteSpace(update.Ime) && update.Ime != entity.Korisnik.Ime)
            {
                entity.Korisnik.Ime = update.Ime;
            }

            if (!string.IsNullOrWhiteSpace(update.Prezime) && update.Prezime != entity.Korisnik.Prezime)
            {
                entity.Korisnik.Prezime = update.Prezime;
            }
            // Ako dolazi nova slika
           /* if (update.SlikaId.HasValue && update.SlikaId != entity.SlikaId)
            {
                // Ako već postoji stara slika, brišemo je iz baze
                if (entity.SlikaId.HasValue)
                {
                    var staraSlika = await _context.ZaposlenikSlikes.FindAsync(entity.SlikaId.Value);
                    if (staraSlika != null)
                    {
                        _context.ZaposlenikSlikes.Remove(staraSlika);
                    }
                }

                // Dodaj novu vezu prema slici
                entity.SlikaId = update.SlikaId;
                
            }*/
            _mapper.Map(update, entity);
            entity.Status=update.Status;
            // Spasi promjene
            _context.Zaposleniks.Update(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Zaposlenik>(entity);
        }



        /*public override async Task<Model.Zaposlenik> Delete(int id)
        {
            var entity = _context.Zaposleniks.Find(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("Zaposlenik nije pronađen.");
            }

            _context.Zaposleniks.Remove(entity);
            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Zaposlenik>(entity);
        }*/
        public override async Task<bool> Delete(int id)
        {
            var entity = _context.Zaposleniks.Find(id);

            if (entity == null)
            {
                return false;
            }

            // Brišemo povezane rezervacije i recenzije (pretpostavljeni nazivi)
            var rezervacije = await _context.Rezervacijas
                .Where(r => r.ZaposlenikId == entity.Id)
                .ToListAsync();

            var recenzije = await _context.ZaposlenikRecenzijas // ili Komentari ako ih tako zoveš
                .Where(o => o.ZaposlenikId == entity.Id)
                .ToListAsync();

            if (rezervacije.Any())
            {
                _context.Rezervacijas.RemoveRange(rezervacije);
            }

            if (recenzije.Any())
            {
                _context.ZaposlenikRecenzijas.RemoveRange(recenzije);
            }

            // Brišemo korisničke uloge
            var korisnikUloge = await _context.KorisnikUlogas
                .Where(ku => ku.KorisnikId == entity.KorisnikId)
                .ToListAsync();

            if (korisnikUloge.Any())
            {
                _context.KorisnikUlogas.RemoveRange(korisnikUloge);
            }

            // Brišemo korisnika
            var korisnikEntity = await _context.Korisniks.FindAsync(entity.KorisnikId);
            if (korisnikEntity != null)
            {
                _context.Korisniks.Remove(korisnikEntity);
            }

            // Brišemo zaposlenika
            _context.Zaposleniks.Remove(entity);

            await _context.SaveChangesAsync();

            return true;
        }


    }
}
