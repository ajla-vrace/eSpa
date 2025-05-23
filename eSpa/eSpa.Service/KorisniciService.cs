﻿using AutoMapper;
using eSpa.Model;
using eSpa.Model.Requests;
using eSpa.Model.SearchObject;
using eSpa.Service.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using RabbitMQ.Client;
using System.Text;
using System.Text.Json;
using eSpa.Services;

namespace eSpa.Service
{
    public class KorisniciService : BaseCRUDService<Model.Korisnik, Database.Korisnik, Model.SearchObject.KorisnikSearchObject, Model.Requests.KorisnikInsertRequest, Model.Requests.KorisnikUpdateRequest>, IKorisniciService
    {
        //eSpaContext _context;
        protected IRabbitMQProducer _rabbitMQProducer;
        //protected IRabbitMQProducer _rabbitMQProducer;
        public KorisniciService(IB200069Context context, IMapper mapper, IRabbitMQProducer rabbitMQProducer) : base(context, mapper)
        {
            // _context = context;
            _rabbitMQProducer = rabbitMQProducer;

        }
        /*public KorisniciService(EProdajaContext context, IMapper mapper)
            : base(context, mapper)
        {
        }

        public override async Task BeforeInsert(Korisnici entity, KorisniciInsertRequest insert)
        {
            entity.LozinkaSalt = GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, insert.Password);
        }


        public static string GenerateSalt()
        {
            RNGCryptoServiceProvider provider = new RNGCryptoServiceProvider();
            var byteArray = new byte[16];
            provider.GetBytes(byteArray);


            return Convert.ToBase64String(byteArray);
        }
        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }


        public override IQueryable<Korisnici> AddInclude(IQueryable<Korisnici> query, KorisniciSearchObject? search = null)
        {
            if (search?.IsUlogeIncluded == true)
            {
                query = query.Include("KorisniciUloges.Uloga");
            }
            return base.AddInclude(query, search);
        }
        
        public async Task<Model.Korisnici> Login(string username, string password)
        {
            var entity = await _context.Korisnicis.Include("KorisniciUloges.Uloga").FirstOrDefaultAsync(x => x.KorisnickoIme == username);

            if (entity == null)
            {
                return null;
            }

            var hash = GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                return null;
            }

            return _mapper.Map<Model.Korisnici>(entity);
        }*/

        /*public override IQueryable<Database.Korisnik> AddInclude(IQueryable<Database.Korisnik> query, KorisnikSearchObject? search = null)
        {
            if (search?.IsUlogeIncluded == true)
            {
                query = query.Include("KorisnikUloges.Uloga"); //ovdje promjena 
            }
            return base.AddInclude(query, search);
        }*/
        /* public override IQueryable<Database.Korisnik> AddInclude(IQueryable<Database.Korisnik> query, KorisnikSearchObject? search = null)
         {
             if (search?.IsUlogeIncluded == true)
             {
                 query = query.Include(k => k.KorisnikUlogas) // Uključujemo 'KorisnikUlogas'
                       .ThenInclude(ku => ku.Uloga);
             }
             return base.AddInclude(query, search);
         }*/
        /*
        public override async Task<PagedResult<Model.Korisnik>> Get(KorisnikSearchObject? search)
        {
            //var list = _context.Set<TDb>().AsQueryable();
            //var query=_context.Set<TDb>().AsQueryable();
            //var list = await query.ToListAsync();
            var query = _context.Set<Database.Korisnik>().AsQueryable();

            PagedResult<Model.Korisnik> result = new PagedResult<Model.Korisnik>();


            query = AddFilter(query, search);
            query = AddInclude(query, search);

            result.Count = await query.CountAsync();

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Take(search.PageSize.Value).Skip(search.Page.Value * search.PageSize.Value);
            }
            var list = await query.ToListAsync();


            var tmp = _mapper.Map<List<Model.Korisnik>>(list);
            result.Result = tmp;
            return result;

            //return _mapper.Map<List<T>>(list);
        }
        */
        /*
        public  async Task<PagedResult<Model.Korisnik>> Get(KorisnikSearchObject? search)
        {
            var query = _context.Set<Database.Korisnik>().AsQueryable();

            // Možeš dodati filtriranje, ako je potrebno
            query = AddFilter(query, search);
            query = AddInclude(query, search);
            PagedResult<Model.Korisnik> result = new PagedResult<Model.Korisnik>();

            result.Count = await query.CountAsync();

            // Paginacija (ako je potrebno)
            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Skip(search.Page.Value * search.PageSize.Value)
                             .Take(search.PageSize.Value);
            }

            var list = await query.ToListAsync();

            // Mapiramo entitet (Database.Korisnik) u Model.Korisnik i dodajemo uloge
            var korisniciModel = list.Select(k => new Model.Korisnik
            {
                Id = k.Id,
                Ime = k.Ime,
                Prezime = k.Prezime,
                Email = k.Email,
                Telefon = k.Telefon,
                DatumRegistracije = k.DatumRegistracije,
                KorisnickoIme = k.KorisnickoIme,
                Status = k.Status,
                IsAdmin = k.IsAdmin,
                IsBlokiran = k.IsBlokiran,
                IsZaposlenik = k.IsZaposlenik,
                KorisnikUlogas = k.KorisnikUlogas.Select(ku => new Model.KorisnikUloga
                {
                    Id = ku.Id,
                    UlogaId = ku.UlogaId,
                    DatumDodele = (DateTime)ku.DatumDodele,
                    Uloga = new Model.Uloga
                    {
                        Id = ku.Uloga.Id,
                        Naziv = ku.Uloga.Naziv
                    }
                }).ToList()
            }).ToList();

            result.Result = korisniciModel;

            return result;
        }
        */

        /*public override async Task<Model.Korisnik> GetById(int id)
        {
            var entity = await _context.Set<Database.Korisnik>().FindAsync(id);
            
            return _mapper.Map<Model.Korisnik>(entity);
        }*/
        public override async Task<PagedResult<Model.Korisnik>> Get(KorisnikSearchObject? search)
        {
            //var list = _context.Set<TDb>().AsQueryable();
            //var query=_context.Set<TDb>().AsQueryable();
            //var list = await query.ToListAsync();
            var query = _context.Set<Database.Korisnik>().AsQueryable();

            PagedResult<Model.Korisnik> result = new PagedResult<Model.Korisnik>();


            query = AddFilter(query, search);
            //query = AddInclude(query, search);
            query = query.Include(k => k.KorisnikUlogas)// Uključujemo 'KorisnikUlogas'
                        .ThenInclude(ku => ku.Uloga);
            result.Count = await query.CountAsync();

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Take(search.PageSize.Value).Skip(search.Page.Value * search.PageSize.Value);
            }
            var list = await query.ToListAsync();


            var tmp = _mapper.Map<List<Model.Korisnik>>(list);
            result.Result = tmp;
            return result;

            //return _mapper.Map<List<T>>(list);
        }



        public override async Task<Model.Korisnik> GetById(int id)
        {
            var entity = await _context.Set<Database.Korisnik>()
                .Include(k => k.KorisnikUlogas)  // Uključivanje povezanih uloga
                .ThenInclude(ku => ku.Uloga)    // Uključivanje podataka o ulogama
                .FirstOrDefaultAsync(k => k.Id == id);  // Dohvat korisnika prema ID-u

            if (entity == null)
            {
                return null;  // Ili baciti neku grešku, zavisno od tvojih potreba
            }

            return _mapper.Map<Model.Korisnik>(entity);
        }






        public override IQueryable<Database.Korisnik> AddInclude(IQueryable<Database.Korisnik> query, KorisnikSearchObject? search = null)
    {
        if (search?.IsUlogeIncluded == true)
        {
                //query = query.Include("KorisniciUloges.Uloga");
                query = query.Include(k => k.KorisnikUlogas)// Uključujemo 'KorisnikUlogas'
                          .ThenInclude(ku => ku.Uloga);
            }
        return base.AddInclude(query, search);
    }
        public override IQueryable<Database.Korisnik> AddFilter(IQueryable<Database.Korisnik> query, KorisnikSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Ime))
            {
                filteredQuery = filteredQuery.Where(x => x.Ime.Contains(search.Ime));
            }

            if (!string.IsNullOrWhiteSpace(search?.Prezime))
            {
                filteredQuery = filteredQuery.Where(x => x.Prezime.Contains(search.Prezime));
            }

            if (!string.IsNullOrWhiteSpace(search?.KorisnickoIme))
            {
                filteredQuery = filteredQuery.Where(x => x.KorisnickoIme == search.KorisnickoIme);
            }

            if (!string.IsNullOrWhiteSpace(search?.Status))
            {
                filteredQuery = filteredQuery.Where(x => x.Status == search.Status);
            }

            if (search?.isZaposlenik.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.IsZaposlenik == search.isZaposlenik);
            }
            if (search?.isAdmin.HasValue == true)
            {
                filteredQuery = filteredQuery.Where(x => x.IsAdmin == search.isAdmin);
            }

            return filteredQuery.Include(x => x.Slika);
        }

        /* public override IQueryable<Database.Korisnik> AddFilter(IQueryable<Database.Korisnik> query, KorisnikSearchObject? search = null)
             {
                 var filteredQuery = base.AddFilter(query, search);

                 // Ako su svi parametri prisutni (ime, prezime, korisničko ime, status)
                 if (!string.IsNullOrWhiteSpace(search?.Ime) &&
                     !string.IsNullOrWhiteSpace(search?.Prezime) &&
                     !string.IsNullOrWhiteSpace(search?.KorisnickoIme) &&
                     !string.IsNullOrWhiteSpace(search?.Status))
                 {
                     filteredQuery = filteredQuery.Where(x =>
                         x.Ime.Contains(search.Ime) &&
                         x.Prezime.Contains(search.Prezime) &&
                         x.KorisnickoIme==(search.KorisnickoIme) &&
                         x.Status == search.Status);
                 }
                 else
                 {
                     // Ako su uneti samo pojedinačni parametri, filtriraj samo po njima
                     if (!string.IsNullOrWhiteSpace(search?.Ime))
                     {
                         filteredQuery = filteredQuery.Where(x => x.Ime.Contains(search.Ime));
                     }

                     if (!string.IsNullOrWhiteSpace(search?.Prezime))
                     {
                         filteredQuery = filteredQuery.Where(x => x.Prezime.Contains(search.Prezime));
                     }

                     if (!string.IsNullOrWhiteSpace(search?.KorisnickoIme))
                     {
                         filteredQuery = filteredQuery.Where(x => x.KorisnickoIme==(search.KorisnickoIme));
                     }

                     if (!string.IsNullOrWhiteSpace(search?.Status))
                     {
                         filteredQuery = filteredQuery.Where(x => x.Status == search.Status);
                     }
                     if (search?.isZaposlenik.HasValue == true)
                     {
                         filteredQuery = filteredQuery.Where(x => x.IsZaposlenik == search.isZaposlenik);
                     }

                 }
                 filteredQuery = filteredQuery
                                     .Include(x => x.Slika);
                 return filteredQuery;
             }*/




        public static string GenerateSalt()
        {
            RNGCryptoServiceProvider provider = new RNGCryptoServiceProvider();
            var byteArray = new byte[16];
            provider.GetBytes(byteArray);


            return Convert.ToBase64String(byteArray);
        }
        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }
        public override async Task BeforeInsert(Database.Korisnik entity, KorisnikInsertRequest insert)
        {
            entity.LozinkaSalt = GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, insert.Password);
        }
        /*public override Task<Model.Korisnik> Insert(KorisnikInsertRequest insert)
        {
            return base.Insert(insert);
        }*/

        public async Task<Model.Korisnik> Login(string username, string password)
        {
            //ovdje promjena
            var entity = await _context.Korisniks.Include("KorisnikUlogas.Uloga").FirstOrDefaultAsync(x => x.KorisnickoIme == username);

           /* var entity = await _context.Korisniks
    .Include(k => k.KorisnikUlogas) // uključite sve korisničke uloge
    .ThenInclude(ku => ku.Uloga)    // uključite povezane uloge za svaku korisničku ulogu
    .FirstOrDefaultAsync(x => x.KorisnickoIme == username);
           */


            if (entity == null)
            {
                return null;
            }

            var hash = GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                return null;
            }

            return _mapper.Map<Model.Korisnik>(entity);
        }


        public override async Task<Model.Korisnik> Insert(KorisnikInsertRequest insert)
        {
            // Kreiraj novi entitet na osnovu request-a
            /*if (_context.Korisniks.Any(k => k.Email == insert.Email))
            {
                throw new Exception("Korisnik sa ovom e-mail adresom već postoji.");
            }*/
            if (_context.Korisniks.Any(k => k.KorisnickoIme == insert.KorisnickoIme))
            {
                // throw new Exception("Korisnik sa ovim korisnickim imenom već postoji.");
                // Umesto generičke greške, koristi odgovarajući status kod
                throw new Exception("Korisničko ime već postoji.");
            }
            var entity = _mapper.Map<Database.Korisnik>(insert);

            // Postavi trenutni datum
            entity.DatumRegistracije = DateTime.Now;
            entity.IsAdmin = false;
            entity.IsBlokiran = false;
            entity.IsZaposlenik = false;
            entity.Status = "Aktivan";
            entity.LozinkaSalt = GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, insert.Password);
            // Dodaj u bazu podataka
            _context.Korisniks.Add(entity);

            await _context.SaveChangesAsync();
            // SendKorisnikPoruka(entity.Ime, entity.Email);


            /*var klijentEmail = insert.Email;
            var factory = new ConnectionFactory
            {
                HostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "172.17.0.2",
                Port = int.Parse(Environment.GetEnvironmentVariable("RABBITMQ_PORT") ?? "5672"),
                UserName = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest",
                Password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest",
                RequestedConnectionTimeout = TimeSpan.FromSeconds(30),
                RequestedHeartbeat = TimeSpan.FromSeconds(60),
                AutomaticRecoveryEnabled = true,
                NetworkRecoveryInterval = TimeSpan.FromSeconds(10),
            };

            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(queue: "reservation_created",
                                 durable: factory.HostName == "rabbit-server" ? false : true,
                                 exclusive: false,
                                 autoDelete: false,
                                 arguments: null);

            string message = $"Rezervacija_je_kreirana!_email_{klijentEmail}_usluga__termin__datum_";
            var body = Encoding.UTF8.GetBytes(message);

            channel.BasicPublish(exchange: string.Empty,
                                 routingKey: "reservation_created",
                                 basicProperties: null,
                                 body: body);


            */










            await AfterInsert(entity, insert);

            // Vrati mapirani model
            return _mapper.Map<Model.Korisnik>(entity);
        }

        /*public override async Task AfterInsert(Database.Korisnik entity, KorisnikInsertRequest insert)
        {
            if (insert.Email != null && insert.Email != "")
            {
                Model.Email email = new()
                {
                    Subject = "Pozdravni mail",
                    Content = "Welcome to eSpa! ",
                    Recipient = insert.Email,
                    Sender = "probaa.probaa1234@gmail.com",
                };
                _rabbitMQProducer.SendMessage(email);
            }
        }*/
        public override async Task AfterInsert(Database.Korisnik entity, KorisnikInsertRequest insert)
        {
            if (!string.IsNullOrWhiteSpace(insert.Email))
            {
                string imeKorisnika = entity.Ime;

                Model.Email email = new()
                {
                    Subject = "Pozdravni mail",
                    Content = $"Dragi {imeKorisnika},\n\nDobrodošli u eSpa – vaše osobno utočište za opuštanje i njegu!\n\nDrago nam je što ste postali dio naše zajednice. Naša misija je pružiti vam vrhunsko iskustvo, bilo da rezervirate omiljene tretmane, otkrivate nove usluge ili jednostavno izdvajate vrijeme za sebe.\n\nVaše putovanje prema opuštanju i obnovi započinje upravo sada. Slobodno istražite našu ponudu i javite nam se ako vam je potrebna pomoć.\n\nHvala što ste odabrali eSpa – mjesto gdje je vaše zadovoljstvo na prvom mjestu.\n\nSrdačno,\nVaš eSpa tim",
                    Recipient = insert.Email,
                    Sender = "probaa.probaa1234@gmail.com",
                };

                _rabbitMQProducer.SendMessage(email);
            }
        }



        /* public override async Task<Model.Korisnik> Update(int id, KorisnikUpdateRequest update)
         {
             var entity = await _context.Korisniks.FindAsync(id);
             if (entity == null)
             {
                 throw new KeyNotFoundException("Korisnik nije pronađen.");
             }

             _mapper.Map(update, entity);
             //entity.DatumRegistracije = DateTime.Now;

             _context.Korisniks.Update(entity);
             await _context.SaveChangesAsync();

             return _mapper.Map<Model.Korisnik>(entity);
         }*/


        /* private void PosaljitePorukuNaRabbitMQ(Korisnik korisnik)
         {
             var factory = new ConnectionFactory() { HostName = "localhost" };  // Povezivanje na lokalni RabbitMQ server
             using (var connection = factory.CreateConnection())
             using (var channel = connection.CreateModel())
             {
                 channel.QueueDeclare(queue: "korisniciQueue", durable: false, exclusive: false, autoDelete: false, arguments: null);

                 var korisnikEmailMessage = new KorisnikEmailMessage
                 {
                     Ime = korisnik.Ime,
                     Email = korisnik.Email
                 };

                 var body = Encoding.UTF8.GetBytes(JsonSerializer.Serialize(korisnikEmailMessage));

                 channel.BasicPublish(exchange: "", routingKey: "korisniciQueue", basicProperties: null, body: body);
                 Console.WriteLine($"[x] Poslata poruka za korisnika {korisnik.Email}");
             }
         }*/




        public override async Task<Model.Korisnik> Update(int id, KorisnikUpdateRequest update)
        {
            var entity = await _context.Korisniks
                .Include(k => k.KorisnikUlogas) // Učitaj povezane uloge
                .FirstOrDefaultAsync(k => k.Id == id);

            if (entity == null)
            {
                throw new KeyNotFoundException("Korisnik nije pronađen.");
            }

            _mapper.Map(update, entity);

            // Ako je korisnik postavljen kao admin, dodeli mu Admin ulogu
            if (entity.IsAdmin == true)
            {
                var adminUloga = await _context.Ulogas.FirstOrDefaultAsync(u => u.Naziv == "Administrator");

                if (adminUloga != null && !entity.KorisnikUlogas.Any(ku => ku.UlogaId == adminUloga.Id))
                {
                    entity.KorisnikUlogas.Add(new Database.KorisnikUloga
                    {
                        KorisnikId = entity.Id,
                        UlogaId = adminUloga.Id,
                        DatumDodele = DateTime.Now
                    }); ;
                }
            }
            else
            {
                var adminUloga = await _context.Ulogas.FirstOrDefaultAsync(u => u.Naziv == "Administrator");

                if (adminUloga != null)
                {
                    var korisnikUloga = entity.KorisnikUlogas.FirstOrDefault(ku => ku.UlogaId == adminUloga.Id);
                    if (korisnikUloga != null)
                    {
                        _context.KorisnikUlogas.Remove(korisnikUloga);
                    }
                }
            }
            if (update.SlikaId.HasValue && update.SlikaId != entity.SlikaId)
            {
                // Ako već postoji stara slika, brišemo je iz baze
                if (entity.SlikaId.HasValue)
                {
                    var staraSlika = await _context.SlikaProfilas.FindAsync(entity.SlikaId.Value);
                    if (staraSlika != null)
                    {
                        _context.SlikaProfilas.Remove(staraSlika);
                    }
                }

                // Dodaj novu vezu prema slici
                entity.SlikaId = update.SlikaId;
            }

                _context.Korisniks.Update(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Korisnik>(entity);
        }
        public async Task BlokirajKorisnika(int korisnikId)
        {
            var korisnik = await _context.Korisniks.FindAsync(korisnikId);

            if (korisnik == null)
                throw new Exception("Korisnik nije pronađen");

            korisnik.Status = "Blokiran";
            korisnik.IsBlokiran = true;

            // Uklanjanje svih aktivnih i na čekanju rezervacija korisnika
            var rezervacijeZaObrisati = await _context.Rezervacijas
                .Where(r => r.KorisnikId == korisnikId &&
                            (r.Status == "Aktivna" || r.Status == "Na čekanju"))
                .ToListAsync();

            // Brisanje svih rezervacija korisnika
            _context.Rezervacijas.RemoveRange(rezervacijeZaObrisati);

            await _context.SaveChangesAsync();
        }








        public async Task ChangePasswordAsync(ChangePasswordRequest model)
        {
            var user = await _context.Korisniks.FindAsync(model.Id);
            if (user == null)
            {
                throw new Exception("Korisnik nije pronadjen.");
            }

            // Provjeri da li je stara lozinka tačna
            if (user.LozinkaHash != GenerateHash(user.LozinkaSalt, model.StariPassword))
            {
                throw new Exception("Netacan stari password.");
            }

            // Provjeri da li su nova lozinka i potvrda iste
            if (model.NoviPassword != model.PotvrdaPassword)
            {
                throw new Exception("Novi password i potvrda se ne podudaraju.");
            }

            // Šifriraj novu lozinku
            user.LozinkaSalt = GenerateSalt();
            user.LozinkaHash = GenerateHash(user.LozinkaSalt, model.NoviPassword);

            _context.Update(user);
            await _context.SaveChangesAsync();
        }
    }
}
