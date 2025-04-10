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
using eSpa.Model;
using Microsoft.AspNetCore.Http;

namespace eSpa.Service
{
    public class NovostService:BaseCRUDService<Model.Novost,Database.Novost,NovostSearchObject,NovostInsertRequest,NovostUpdateRequest>,INovostService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;

        public NovostService(eSpaContext context, IMapper mapper, IHttpContextAccessor httpContextAccessor) : base(context, mapper)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        public override IQueryable<Database.Novost> AddFilter(IQueryable<Database.Novost> query, NovostSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            /*if (!string.IsNullOrWhiteSpace(search?.FTS) )
            {
                filteredQuery = filteredQuery.Where(x => x.Naslov.Contains(search.FTS));
            }*/
            if (!string.IsNullOrWhiteSpace(search.Naslov) &&
           !string.IsNullOrWhiteSpace(search.Autor) &&
           !string.IsNullOrWhiteSpace(search.Status))
            {
                filteredQuery = filteredQuery.Where(x =>
                    x.Naslov.Contains(search.Naslov) &&
                    (x.Autor.KorisnickoIme.Contains(search.Autor) &&
                    x.Status == search.Status));
            }
            else
            {
                // Ako su uneti samo pojedinačni parametri, filtriraj samo po njima
                if (!string.IsNullOrWhiteSpace(search.Naslov))
                {
                    filteredQuery = filteredQuery.Where(x => x.Naslov.Contains(search.Naslov));
                }

                if (!string.IsNullOrWhiteSpace(search.Autor))
                {
                    filteredQuery = filteredQuery.Where(x => x.Autor.KorisnickoIme.Contains(search.Autor));
                }

                if (!string.IsNullOrWhiteSpace(search.Status))
                {
                    filteredQuery = filteredQuery.Where(x => x.Status == search.Status);
                }
            }


            filteredQuery = filteredQuery.Include(x => x.Autor);


            return filteredQuery;
        }



        /* private int GetCurrentUserId()
         {
             var user = _httpContextAccessor.HttpContext?.User;

             if (user == null)
                 throw new UnauthorizedAccessException("Korisnik nije prijavljen.");

             var userIdClaim = user.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier);

             if (userIdClaim == null)
                 throw new UnauthorizedAccessException("ID korisnika nije pronađen u tokenu.");

             return int.Parse(userIdClaim.Value);
         }*/
        /*private int GetCurrentUserId()
        {
            var user = _httpContextAccessor.HttpContext?.User;

            if (user == null)
                throw new UnauthorizedAccessException("Korisnik nije prijavljen.");

            // Prikaz svih claimova u logu (za debugging)
            foreach (var claim in user.Claims)
            {
                Console.WriteLine($"Claim Type: {claim.Type}, Value: {claim.Value}");
            }

            var userIdClaim = user.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier);

            if (userIdClaim == null)
                throw new UnauthorizedAccessException("ID korisnika nije pronađen u tokenu.");

            if (int.TryParse(userIdClaim.Value, out int userId))
            {
                return userId;
            }
            else
            {
                throw new FormatException($"ID korisnika nije u ispravnom formatu: {userIdClaim.Value}");
            }
        }
        */
        private string GetUsernameFromAuthHeader()
        {
            var authorizationHeader = _httpContextAccessor.HttpContext?.Request.Headers["Authorization"].ToString();

            if (string.IsNullOrEmpty(authorizationHeader) || !authorizationHeader.StartsWith("Basic "))
            {
                throw new UnauthorizedAccessException("Nedostaje Authorization header ili nije u Basic formatu.");
            }

            // Uzimamo samo base64 kodirani deo nakon "Basic "
            var encodedCredentials = authorizationHeader.Substring(6);  // Skida "Basic " sa početka

            try
            {
                // Dekodiraj base64
                var decodedCredentials = Encoding.UTF8.GetString(Convert.FromBase64String(encodedCredentials));

                // Format treba da bude "username:password"
                var credentials = decodedCredentials.Split(':');

                if (credentials.Length != 2)
                {
                    throw new UnauthorizedAccessException("Neispravan format Basic autentifikacije.");
                }

                // Vraćamo samo korisničko ime
                return credentials[0];
            }
            catch (FormatException)
            {
                throw new UnauthorizedAccessException("Greška u dekodiranju Basic auth header-a.");
            }
        }

        /*private int GetCurrentUserId()
        {
            var user = _httpContextAccessor.HttpContext?.Request.Headers["Authorization"].ToString();

            if (string.IsNullOrEmpty(user))
                throw new UnauthorizedAccessException("Korisnik nije prijavljen.");

            // Koristi username iz Basic auth za traženje korisnika u bazi
            var username = user.Split(' ')[1]; // Uzimanje korisničkog imena (nakon "Basic ")

            var korisnik = _context.Korisniks.FirstOrDefault(k => k.KorisnickoIme == username);

            if (korisnik == null)
                throw new UnauthorizedAccessException("Korisnik sa tim korisničkim imenom nije pronađen.");

            return korisnik.Id;
        }*/
        private int GetCurrentUserId()
        {
            // Dobijamo korisničko ime iz Basic Authentication header-a
            var username = GetUsernameFromAuthHeader();

            // Proveravamo da li postoji korisnik u bazi sa tim korisničkim imenom
            var korisnik = _context.Korisniks.FirstOrDefault(k => k.KorisnickoIme == username);

            if (korisnik == null)
                throw new UnauthorizedAccessException("Korisnik sa tim korisničkim imenom nije pronađen.");

            return korisnik.Id;
        }





        public async override Task<Model.Novost> Insert(NovostInsertRequest insert)
        {

            var entity = _mapper.Map<Database.Novost>(insert);

            entity.DatumKreiranja = DateTime.Now;
            //entity.DatumKreiranja = DateTime.Now;
            entity.Status = "Aktivna";
           entity.AutorId = GetCurrentUserId();
            _context.Novosts.Add(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Novost>(entity);

        }

        public override async Task<Model.Novost> Update(int id, NovostUpdateRequest update)
        {
            var entity = await _context.Novosts.FindAsync(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("Novost nije pronađena.");
            }

            _mapper.Map(update, entity);
            entity.DatumKreiranja = DateTime.Now;

            _context.Novosts.Update(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Novost>(entity);
        }

        public override async Task<Model.Novost> Delete(int id)
        {
            var entity = _context.Novosts.Find(id);
            if (entity == null)
            {
                throw new KeyNotFoundException("Novost nije pronađena.");
            }

            _context.Novosts.Remove(entity);
           await  _context.SaveChangesAsync();
            return _mapper.Map<Model.Novost>(entity);
        }
    }
}
