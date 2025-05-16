//using eSpa.Service.Database;
using eSpa;
using eSpa.Filters;
//using eSpa.Model;
//using eSpa.Models;
using eSpa.Service;
using eSpa.Service.Database;
using eSpa.Services;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using System.Security.Cryptography;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers(/* x=> {
        x.Filters.Add<ErrorFilter>();
    }*/);
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
//builder.Services.AddSwaggerGen();

builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth"}
            },
            new string[]{}
    } });

});



var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<IB200069Context>(options => options.UseSqlServer(connectionString));
builder.Services.AddAutoMapper(typeof(IKategorijaService));  //prije bilo startup

//builder.Services.AddAuthentication("BasicAuthentication")
// .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);


builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);

builder.Services.AddHttpContextAccessor(); //dodano novo

builder.Services.AddTransient<IKorisniciService, KorisniciService>(); //plus dodat sve ostalo
//builder.Services.AddScoped<IUslugaService, UslugaService>();
builder.Services.AddTransient<IKategorijaService, KategorijaService>();
builder.Services.AddTransient<IUslugaService, UslugaService>();
builder.Services.AddTransient<IZaposlenikService, ZaposlenikService>();
//builder.Services.AddTransient<IKategorijaService, KategorijaService>();
builder.Services.AddTransient<IKomentarService, KomentarService>();
builder.Services.AddTransient<INovostKomentarService, NovostKomentarService>();
builder.Services.AddTransient<INovostService, NovostService>();
builder.Services.AddTransient<IOcjenaService, OcjenaService>();
builder.Services.AddTransient<IStatusRezervacijeService, StatusRezervacijeService>();
builder.Services.AddTransient<ITerminService, TerminService>();
builder.Services.AddTransient<IRezervacijaService, RezervacijaService>();
//builder.Services.AddTransient<IZaposlenikSlikeService, ZaposlenikSlikeService>();
builder.Services.AddTransient<IUlogaService, UlogaService>();
builder.Services.AddTransient<INovostInterakcijaService, NovostInterakcijaService>();
builder.Services.AddTransient<ISlikaProfilaService, SlikaProfilaService>();
builder.Services.AddTransient<IFavoritService, FavoritService>();
builder.Services.AddTransient<IKorisnikUlogaService, KorisnikUlogaService>();
builder.Services.AddTransient<IRabbitMQProducer, RabbitMQProducer>();
builder.Services.AddTransient<IZaposlenikRecenzijaService, ZaposlenikRecenzijaService>();
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

//app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();

app.Urls.Add("http://0.0.0.0:5031");

app.MapControllers();

/*using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<IB200069Context>();

    if (!dataContext.Database.CanConnect())
    {
        dataContext.Database.Migrate();

        /*var recommenderService = scope.ServiceProvider.GetRequiredService<IRecommenderService>();
        try
        {
            await recommenderService.TrainAnimeModelAsync();
        }
        catch (Exception)
        {

        }*/
//}
//}

using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<IB200069Context>();
    db.Database.Migrate();  // Pokreće migracije (ako postoje)

    // Seed kategorije

    
    string password = "test"; // Same password for demonstration

    string salt1 = GenerateSalt();
    string hash1 = GenerateHash(salt1, password);

    // Seed uloge



    // Generisanje lozinke, salt-a i hash-a

    
        db.Korisniks.AddRange(
        new Korisnik
        {
            Ime = "Admin",
            Prezime = "Admin",
            Email = "admin@gmail.com",
            Telefon = "061234567",
            DatumRegistracije = DateTime.Now,
            KorisnickoIme = "admin",
            LozinkaSalt = salt1,
            LozinkaHash = hash1,
            Status = "Aktivan", // ili neka druga vrednost
            IsAdmin = true,
            IsBlokiran = false,
            IsZaposlenik = false,
            SlikaId = null
        },
        new Korisnik
        {
            Ime = "Jana",
            Prezime = "Jovanović",
            Email = "jana@gmail.com",
            Telefon = "062345678",
            DatumRegistracije = DateTime.Now,
            KorisnickoIme = "terapeut",
            LozinkaSalt = salt1,
            LozinkaHash = hash1,
            Status = "Aktivan",
            IsAdmin = false,
            IsBlokiran = false,
            IsZaposlenik = true,
            SlikaId = null
        },
        new Korisnik
        {
            Ime = "Nikola",
            Prezime = "Nikolić",
            Email = "nikola@email.com",
            Telefon = "061456789",
            DatumRegistracije = DateTime.Now,
            KorisnickoIme = "terapeut2",
            LozinkaSalt = salt1,
            LozinkaHash = hash1,
            Status = "Aktivan",
            IsAdmin = false,
            IsBlokiran = false,
            IsZaposlenik = true,
            SlikaId = null
        },
        new Korisnik
        {
            Ime = "Ivana",
            Prezime = "Ivanović",
            Email = "ivana@email.com",
            Telefon = "061567890",
            DatumRegistracije = DateTime.Now,
            KorisnickoIme = "ivana",
            LozinkaSalt = salt1,
            LozinkaHash = hash1,
            Status = "Aktivan",
            IsAdmin = false,
            IsBlokiran = false,
            IsZaposlenik = false,
            SlikaId = null
        },
        new Korisnik
        {
            Ime = "Milan",
            Prezime = "Milanović",
            Email = "milan@email.com",
            Telefon = "061678901",
            DatumRegistracije = DateTime.Now,
            KorisnickoIme = "milan123",
            LozinkaSalt = salt1,
            LozinkaHash = hash1,
            Status = "Aktivan",
            IsAdmin = false,
            IsBlokiran = false,
            IsZaposlenik = false,
            SlikaId = null
        },
        new Korisnik
        {
            Ime = "Luka",
            Prezime = "Lukić",
            Email = "luka@email.com",
            Telefon = "061789012",
            DatumRegistracije = DateTime.Now,
            KorisnickoIme = "terapeut1",
            LozinkaSalt = salt1,
            LozinkaHash = hash1,
            Status = "Aktivan",
            IsAdmin = false,
            IsBlokiran = false,
            IsZaposlenik = true,
            SlikaId = null
        },
        new Korisnik
        {
            Ime = "Sara",
            Prezime = "Savić",
            Email = "sara@email.com",
            Telefon = "061890123",
            DatumRegistracije = DateTime.Now,
            KorisnickoIme = "sara123",
            LozinkaSalt = salt1,
            LozinkaHash = hash1,
            Status = "Aktivan",
            IsAdmin = false,
            IsBlokiran = false,
            IsZaposlenik = false,
            SlikaId = null
        },
        new Korisnik
        {
            Ime = "Ana",
            Prezime = "Anić",
            Email = "ana@email.com",
            Telefon = "061901234",
            DatumRegistracije = DateTime.Now,
            KorisnickoIme = "ana123",
            LozinkaSalt = salt1,
            LozinkaHash = hash1,
            Status = "Aktivan",
            IsAdmin = false,
            IsBlokiran = false,
            IsZaposlenik = false,
            SlikaId = null
        }
    );

        db.SaveChanges();
    
    
        db.Kategorijas.AddRange(
      new Kategorija { Naziv = "Masaza" },
      new Kategorija { Naziv = "Tretman" }
  );
        db.SaveChanges();
    
    
        db.Zaposleniks.AddRange(new Zaposlenik
        {
            KorisnikId = 2, // Pretpostavljamo da je korisnik sa ID-jem 1
            DatumZaposlenja = new DateTime(2023, 5, 1),
            Struka = "Terapeut",
            Status = "Aktivan",
            Biografija = "Iskusni terapeut sa više od 5 godina iskustva.",
            KategorijaId = 1 // Pretpostavljamo da je terapija kategorija sa ID-jem 1
        },

        new Zaposlenik
        {
            KorisnikId = 3, // Pretpostavljamo da je korisnik sa ID-jem 2
            DatumZaposlenja = new DateTime(2023, 6, 15),
            Struka = "Terapeut",
            Status = "Aktivan",
            Biografija = "Ima 5 godina iskustva, sve rijeci hvale",
            KategorijaId = 2 // Pretpostavljamo da je administracija kategorija sa ID-jem 2
        },

        new Zaposlenik
        {
            KorisnikId = 6, // Pretpostavljamo da je korisnik sa ID-jem 3
            DatumZaposlenja = new DateTime(2023, 7, 10),
            Struka = "Terapeut",
            Status = "Aktivan",
            Biografija = "Specijalizovan za tretman fizičkog i mentalnog zdravlja.",
            KategorijaId = 1 // Pretpostavljamo da je terapija kategorija sa ID-jem 1
        });

        db.SaveChanges();

    
    

    
    
    

    db.ZaposlenikRecenzijas.AddRange(
    new ZaposlenikRecenzija
    {
        Komentar = "Izvrsna usluga, zaposlenik je bio vrlo ljubazan i profesionalan.",
        Ocjena = 5,
        DatumKreiranja = DateTime.Now,
        ZaposlenikId = 2, // Zaposlenik 2
        KorisnikId = 4   // Korisnik 4
    },
    new ZaposlenikRecenzija
    {
        Komentar = "Zaposlenik se trudio, ali mislim da je moglo biti bolje organizovano.",
        Ocjena = 3,
        DatumKreiranja = DateTime.Now,
        ZaposlenikId = 3, // Zaposlenik 3
        KorisnikId = 5   // Korisnik 5
    },
    new ZaposlenikRecenzija
    {
        Komentar = "Vrlo ljubazan i stručan zaposlenik. Objasnio mi je sve detalje tokom tretmana.",
        Ocjena = 4,
        DatumKreiranja = DateTime.Now,
        ZaposlenikId = 1, // Zaposlenik 6
        KorisnikId = 7   // Korisnik 7
    },
    new ZaposlenikRecenzija
    {
        Komentar = "Zaposlenik je bio odličnan, usluga je bila brza i efikasna.",
        Ocjena = 5,
        DatumKreiranja = DateTime.Now,
        ZaposlenikId = 2, // Zaposlenik 2
        KorisnikId = 8   // Korisnik 8
    },
    new ZaposlenikRecenzija
    {
        Komentar = "Malo su bili zaboravni na neke detalje, ali sve u svemu bila sam zadovoljna.",
        Ocjena = 4,
        DatumKreiranja = DateTime.Now,
        ZaposlenikId = 3, // Zaposlenik 3
        KorisnikId = 4   // Korisnik 4
    },
    new ZaposlenikRecenzija
    {
        Komentar = "Zaposlenik je bio ljubaznan, ali tretman nije ispunio sva moja očekivanja.",
        Ocjena = 2,
        DatumKreiranja = DateTime.Now,
        ZaposlenikId = 1, // Zaposlenik 6
        KorisnikId = 5   // Korisnik 5
    }
);

    db.SaveChanges();
    db.Ulogas.AddRange(
            new Uloga { Naziv = "Administrator" },
            new Uloga { Naziv = "Terapeut" }
        // new Uloga { Naziv = "Rezervacioner" }
        );
    db.SaveChanges();
   

    // Seed status rezervacije

    db.StatusRezervacijes.AddRange(
       // new StatusRezervacije { Naziv = "Na cekanju" },
        new StatusRezervacije { Naziv = "Aktivna" },
        new StatusRezervacije { Naziv = "Otkazana" },
        new StatusRezervacije { Naziv = "Zavrsena" }
    );
    db.SaveChanges();
    db.KorisnikUlogas.AddRange(
    new KorisnikUloga
    {
        KorisnikId = 1,
        UlogaId = 1,
        DatumDodele = DateTime.Now
    },
    new KorisnikUloga
    {
        KorisnikId = 2,
        UlogaId = 2,
        DatumDodele = DateTime.Now
    },
    new KorisnikUloga
    {
        KorisnikId = 3,
        UlogaId = 2,
        DatumDodele = DateTime.Now
    },
    new KorisnikUloga
    {
        KorisnikId = 6,
        UlogaId = 2,
        DatumDodele = DateTime.Now
    }
);
    db.SaveChanges();

    db.Uslugas.AddRange(
     new Usluga
     {
         Naziv = "Švedska masaža",
         Opis = "Klasična tehnika masaže koja koristi duge pokrete, gnječenje i kružne pokrete kako bi opustila tijelo i poboljšala cirkulaciju.",
         Cijena = 60.00m,
         Trajanje = "40",
         KategorijaId = 1,
         Slika = null
     },
     new Usluga
     {
         Naziv = "Masaža svijećama",
         Opis = "Masaža topljenim aromatičnim voskom koji hidratizira kožu i pruža duboku relaksaciju i osjećaj luksuza.",
         Cijena = 70.00m,
         Trajanje = "50",
         KategorijaId = 1,
         Slika = null
     },
     new Usluga
     {
         Naziv = "Sportska masaža",
         Opis = "Intenzivna terapijska masaža usmjerena na mišiće koji se često koriste pri sportskim aktivnostima, idealna za oporavak i prevenciju ozljeda.",
         Cijena = 65.00m,
         Trajanje = "50",
         KategorijaId = 1,
         Slika = null
     },
     new Usluga
     {
         Naziv = "Masaža čokoladom",
         Opis = "Luksuzna masaža koja koristi toplu čokoladu za opuštanje, hidrataciju kože i stimulaciju hormona sreće.",
         Cijena = 80.00m,
         Trajanje = "50",
         KategorijaId = 1,
         Slika = null
     },
     new Usluga
     {
         Naziv = "Mediteranska masaža",
         Opis = "Kombinacija laganih i srednje jakih pokreta uz korištenje mediteranskih eteričnih ulja, pogodna za relaksaciju i obnovu energije.",
         Cijena = 70.00m,
         Trajanje = "45",
         KategorijaId = 1,
         Slika = null
     },
     new Usluga
     {
         Naziv = "Orijentalna masaža",
         Opis = "Tradicionalna masaža inspirirana tehnikama s Istoka, uključuje akupresurne tačke i istezanja za balans tijela i duha.",
         Cijena = 75.00m,
         Trajanje = "50",
         KategorijaId = 1,
         Slika = null
     },
     new Usluga
     {
         Naziv = "Hot Stone masaža",
         Opis = "Opuštajuća masaža uz korištenje toplih bazaltnih kamenja koja pomaže u ublažavanju napetosti, poboljšanju cirkulacije i dubljoj relaksaciji mišića.",
         Cijena = 75.00m,
         Trajanje = "40",
         KategorijaId = 1,
         Slika = null
     },
     new Usluga
     {
         Naziv = "Luksuzni tretman",
         Opis = "Ovaj dubinski tretman lica osmišljen je za intenzivnu regeneraciju i hidrataciju kože. Korištenje čistog kolagena i hijaluronske kiseline pomaže u vraćanju elastičnosti, smanjenju finih linija i bora te pruža trenutni lifting efekt.",
         Cijena = 110.00m,
         Trajanje = "45",
         KategorijaId = 2
     },
    new Usluga
    {
        Naziv = "Čišćenje ultrazvučnom špatulom",
        Opis = "Inovativni tretman koji koristi ultrazvučne talase za nježno, ali dubinsko čišćenje pora, uklanjanje mitisera i mrtvih stanica. Pogodno i za osjetljive tipove kože.",
        Cijena = 60.00m,
        Trajanje = "45",
        KategorijaId = 2
    },
    new Usluga
    {
        Naziv = "Tretman termo-gelom",
        Opis = "Tretman koji koristi termoaktivni gel na bazi kofeina i algi za poticanje cirkulacije i razgradnju masnih naslaga. Umanjuje pojavu celulita i učvršćuje kožu.",
        Cijena = 80.00m,
        Trajanje = "50",
        KategorijaId = 2
    },
    new Usluga
    {
        Naziv = "Njega tijela lavandom",
        Opis = "Umirujući tretman koji uključuje piling lavandom, masažu toplim uljem i nanošenje maske od shea maslaca. Pruža duboku hidrataciju i relaksaciju.",
        Cijena = 95.00m,
        Trajanje = "45",
        KategorijaId = 2
    },
    new Usluga
    {
        Naziv = "Vulkan maska za leđa i ramena",
        Opis = "Tretman sa grijanim vulkanskim blatom koji ublažava napetost i detoksikuje kožu. Idealan za opuštanje mišića leđa i ramena.",
        Cijena = 70.00m,
        Trajanje = "45",
        KategorijaId = 2
    },
    new Usluga
    {
        Naziv = "Hidromasažni tretman refleksoterapija",
        Opis = "Kupka u hidromasažnoj kadi s aromatičnim solima, piling i refleksoterapijska masaža stopala. Djeluje opuštajuće i stimulativno.",
        Cijena = 55.00m,
        Trajanje = "40",
        KategorijaId = 2
    },
    new Usluga
    {
        Naziv = "Tretman alpskim biljem",
        Opis = "Parna kupka u kombinaciji s oblogama od alpskih biljaka. Osvježava disajne puteve, jača imunitet i njeguje kožu.",
        Cijena = 85.00m,
        Trajanje = "60",
        KategorijaId = 2
    },
    new Usluga
    {
        Naziv = "Tretman za osjetljivu kožu sa kamilicom i zobenim mlijekom",
        Opis = "Umirujuća njega za crvenilo i iritacije. Kamilica i zobeno mlijeko jačaju kožnu barijeru i vraćaju ravnotežu.",
        Cijena = 70.00m,
        Trajanje = "50",
        KategorijaId = 2
    }
 );

    db.SaveChanges();
    db.Novosts.AddRange(
    new Novost
    {
        Naslov = "Novo u ponudi: Tretman lavandom i shea maslacem",
        Sadrzaj = "Od sada u našem spa centru možete uživati u potpuno novom tretmanu koji kombinuje umirujuće efekte lavande sa dubinskom njegom shea maslaca. Idealno za opuštanje i hidrataciju kože nakon napornog dana.",
        DatumKreiranja = DateTime.Now,
        AutorId = 1,
        Status = "Aktivna"
    },
   new Novost
   {
       Naslov = "Specijalna ponuda za Dan žena",
       Sadrzaj = "Povodom Dana žena pripremili smo posebne popuste na masaže i tretmane lica. Posjetite nas između 6. i 9. marta i iskoristite priliku za savršenu relaksaciju.",
       DatumKreiranja = new DateTime(2025, 3, 4, 10, 0, 0),
       AutorId = 1,
       Status = "Aktivna"
   }

);
    db.SaveChanges();


    db.Ocjenas.AddRange(
    new Ocjena
    {
        KorisnikId = 4,
        UslugaId = 1,  // Svedska masaža
        Ocjena1 = 5,    // Najviša ocjena
        Datum = DateTime.Now
    },
    new Ocjena
    {
        KorisnikId = 5,
        UslugaId = 2,  // Masaža svijećama
        Ocjena1 = 4,    // Dobra ocjena
        Datum = DateTime.Now
    },
    new Ocjena
    {
        KorisnikId = 7,
        UslugaId = 3,  // Sportska masaža
        Ocjena1 = 3,    // Srednja ocjena
        Datum = DateTime.Now
    },
    new Ocjena
    {
        KorisnikId = 8,
        UslugaId = 1,  // Svedska masaža
        Ocjena1 = 4,    // Dobra ocjena
        Datum = DateTime.Now
    }
);

    db.SaveChanges();

    db.Komentars.AddRange(
    new Komentar
    {
        KorisnikId = 4,
        UslugaId = 1,  // Svedska masaža
        Tekst = "Svedska masaža je bila odlična, veoma opuštajuća!",
        Datum = DateTime.Now,
        Preporuka = true
    },
    new Komentar
    {
        KorisnikId = 5,
        UslugaId = 2,  // Masaža svijećama
        Tekst = "Masaža svijećama je bila prijatna, ali mislim da bi mogla biti malo jača.",
        Datum = DateTime.Now,
        Preporuka = false
    },
    new Komentar
    {
        KorisnikId = 7,
        UslugaId = 3,  // Sportska masaža
        Tekst = "Odlična sportska masaža, pomogla mi je da se oporavim nakon napornog treninga.",
        Datum = DateTime.Now,
        Preporuka = true
    },
    new Komentar
    {
        KorisnikId = 8,
        UslugaId = 1,  // Svedska masaža
        Tekst = "Preporučujem svedsku masažu, maserka je bila vrlo stručna.",
        Datum = DateTime.Now,
        Preporuka = true
    },
    new Komentar
    {
        KorisnikId = 4,
        UslugaId = 2,  // Masaža svijećama
        Tekst = "Masaža svijećama je bila prijatna, ali bih voleo da su svijeće bile toplije.",
        Datum = DateTime.Now,
        Preporuka = false
    },
    new Komentar
    {
        KorisnikId = 5,
        UslugaId = 3,  // Sportska masaža
        Tekst = "Veoma mi se dopala sportska masaža, ali mislim da bi mogla trajati duže.",
        Datum = DateTime.Now,
        Preporuka = true
    }
);

    db.SaveChanges();


    db.NovostKomentars.AddRange(
    new NovostKomentar
    {
        Sadrzaj = "Ova ponuda za Dan žena je fantastična! Planiram da je iskoristim.",
        DatumKreiranja = DateTime.Now,
        NovostId = 1,  // Novost sa ID-jem 1 (Specijalna ponuda za Dan žena)
        KorisnikId = 4  // Korisnik 4
    },
    new NovostKomentar
    {
        Sadrzaj = "Odlična ponuda! Oduvek sam želela da probam masaže. Moram da dođem!",
        DatumKreiranja = DateTime.Now,
        NovostId = 1,  // Novost sa ID-jem 1
        KorisnikId = 5  // Korisnik 5
    },
    new NovostKomentar
    {
        Sadrzaj = "Divna akcija, jako se radujem što će biti popusta za tretmane.",
        DatumKreiranja = DateTime.Now,
        NovostId = 1,  // Novost sa ID-jem 1
        KorisnikId = 7  // Korisnik 7
    },
    new NovostKomentar
    {
        Sadrzaj = "Mislim da bi ponuda mogla biti još bolja sa više opcija za tretmane.",
        DatumKreiranja = DateTime.Now,
        NovostId = 1,  // Novost sa ID-jem 1
        KorisnikId = 8  // Korisnik 8
    },
    new NovostKomentar
    {
        Sadrzaj = "Specijalna ponuda za Dan žena je super ideja, rado ću da dođem.",
        DatumKreiranja = DateTime.Now,
        NovostId = 2,  // Novost sa ID-jem 2 (Nova kolekcija tretmana)
        KorisnikId = 4  // Korisnik 4
    },
    new NovostKomentar
    {
        Sadrzaj = "Tretmani su odlični, ali bih volela da cena bude još sniženija.",
        DatumKreiranja = DateTime.Now,
        NovostId = 2,  // Novost sa ID-jem 2
        KorisnikId = 5  // Korisnik 5
    }
);

    db.SaveChanges();
    db.NovostInterakcijas.AddRange(
    new NovostInterakcija
    {
        NovostId = 1,  // Novost sa ID-jem 1 (Specijalna ponuda za Dan žena)
        KorisnikId = 4,  // Korisnik sa ID-jem 4
        IsLiked = true,  // Korisnik je lajkovao
        Datum = DateTime.Now
    },
    new NovostInterakcija
    {
        NovostId = 1,  // Novost sa ID-jem 1
        KorisnikId = 5,  // Korisnik sa ID-jem 5
        IsLiked = false,  // Korisnik nije lajkovao
        Datum = DateTime.Now
    },
    new NovostInterakcija
    {
        NovostId = 2,  // Novost sa ID-jem 2 (Nova kolekcija tretmana)
        KorisnikId = 7,  // Korisnik sa ID-jem 7
        IsLiked = true,  // Korisnik je lajkovao
        Datum = DateTime.Now
    },
    new NovostInterakcija
    {
        NovostId = 2,  // Novost sa ID-jem 2
        KorisnikId = 8,  // Korisnik sa ID-jem 8
        IsLiked = true,  // Korisnik nije lajkovao
        Datum = DateTime.Now
    }
);

    db.SaveChanges();
    db.Favorits.AddRange(
    new Favorit
    {
        KorisnikId = 4,  // Korisnik sa ID-jem 4
        UslugaId = 1,  // Usluga sa ID-jem 1 (Svenska masaža)
        IsFavorit = true,  // Ova usluga je označena kao favorit
        Datum = DateTime.Now
    },
    new Favorit
    {
        KorisnikId = 5,  // Korisnik sa ID-jem 5
        UslugaId = 3,  // Usluga sa ID-jem 3 (Masaža s vjećem)
        IsFavorit = true,  // Ova usluga je označena kao favorit
        Datum = DateTime.Now
    },
    new Favorit
    {
        KorisnikId = 7,  // Korisnik sa ID-jem 7
        UslugaId = 5,  // Usluga sa ID-jem 5 (Mediteranska masaža)
        IsFavorit = false,  // Ova usluga nije označena kao favorit
        Datum = DateTime.Now
    },
    new Favorit
    {
        KorisnikId = 4,  // Korisnik sa ID-jem 8
        UslugaId = 6,  // Usluga sa ID-jem 6 (Orijentalna masaža)
        IsFavorit = true,  // Ova usluga je označena kao favorit
        Datum = DateTime.Now
    }
);

    db.SaveChanges();
    db.Termins.AddRange(
    new Termin
    {
        Pocetak = new TimeSpan(10, 0, 0),  // Početak termina u 10:00
        Kraj = new TimeSpan(11, 0, 0)      // Kraj termina u 11:00
    },
    new Termin
    {
        Pocetak = new TimeSpan(11, 0, 0),  // Početak termina u 11:00
        Kraj = new TimeSpan(12, 0, 0)      // Kraj termina u 12:00
    },
    new Termin
    {
        Pocetak = new TimeSpan(12, 0, 0),  // Početak termina u 12:00
        Kraj = new TimeSpan(13, 0, 0)      // Kraj termina u 13:00
    },
    new Termin
    {
        Pocetak = new TimeSpan(13, 0, 0),  // Početak termina u 13:00
        Kraj = new TimeSpan(14, 0, 0)      // Kraj termina u 14:00
    },
    new Termin
    {
        Pocetak = new TimeSpan(14, 0, 0),  // Početak termina u 14:00
        Kraj = new TimeSpan(15, 0, 0)      // Kraj termina u 15:00
    },
    new Termin
    {
        Pocetak = new TimeSpan(15, 0, 0),  // Početak termina u 15:00
        Kraj = new TimeSpan(16, 0, 0)      // Kraj termina u 16:00
    }
);

    db.SaveChanges();

    db.Rezervacijas.AddRange(
    new Rezervacija
    {
        KorisnikId = 4,
        UslugaId = 8,  // Povezivanje sa uslugom (ID 1 - Svedska masaža)
        Datum = DateTime.Now.AddDays(1), // Datum rezervacije (na primer, sutra)
        TerminId = 1,  // Termin 10:00 do 11:00
        Status = "Aktivna", // Status rezervacije
        Napomena = "",
        ZaposlenikId = 2,  // Zaposlenik sa ID 2 (terapeut)
        IsPlaceno = true, // Nije plaćeno
        StatusRezervacijeId = 1  // Status "Na čekanju" (ID 1 iz StatusRezervacije)
    },
    new Rezervacija
    {
        KorisnikId = 5,
        UslugaId = 2,  // Povezivanje sa uslugom (ID 2 - Masaža svetlom)
        Datum = DateTime.Now.AddDays(2), // Datum rezervacije (na primer, za dva dana)
        TerminId = 2,  // Termin 11:00 do 12:00
        Status = "Aktivna", // Status rezervacije
        Napomena = "",
        ZaposlenikId = 3,  // Zaposlenik sa ID 3 (terapeut)
        IsPlaceno = true, // Nije plaćeno
        StatusRezervacijeId = 1  // Status "Na čekanju" (ID 1 iz StatusRezervacije)
    },
    new Rezervacija
    {
        KorisnikId = 7,
        UslugaId = 4,  // Povezivanje sa uslugom (ID 4 - Mediteranska masaža)
        Datum = DateTime.Now.AddDays(3), // Datum rezervacije (na primer, za tri dana)
        TerminId = 3,  // Termin 12:00 do 13:00
        Status = "Aktivna", // Status rezervacije
        Napomena = "Molim vas za opuštanje sa laganom muzikom.",
        ZaposlenikId = 1,  // Zaposlenik sa ID 6 (terapeut)
        IsPlaceno = true, // Nije plaćeno
        StatusRezervacijeId = 1  // Status "Na čekanju" (ID 1 iz StatusRezervacije)
    },
    new Rezervacija
    {
        KorisnikId = 8,
        UslugaId = 9,  // Povezivanje sa uslugom (ID 3 - Sportska masaža)
        Datum = DateTime.Now.AddDays(4), // Datum rezervacije (na primer, za četiri dana)
        TerminId = 4,  // Termin 13:00 do 14:00
        Status = "Aktivna", // Status rezervacije
        Napomena = "",
        ZaposlenikId = 2,  // Zaposlenik sa ID 2 (terapeut)
        IsPlaceno = true, // Nije plaćeno
        StatusRezervacijeId = 1  // Status "Na čekanju" (ID 1 iz StatusRezervacije)
    }
);

    db.SaveChanges();
   

}







static string GenerateSalt()
{
    var provider = new RNGCryptoServiceProvider();
    var byteArray = new byte[16];
    provider.GetBytes(byteArray);

    return Convert.ToBase64String(byteArray);
}

static string GenerateHash(string salt, string password)
{
    byte[] src = Convert.FromBase64String(salt);
    byte[] bytes = Encoding.Unicode.GetBytes(password);
    byte[] dist = new byte[src.Length + bytes.Length];

    System.Buffer.BlockCopy(src, 0, dist, 0, src.Length);
    System.Buffer.BlockCopy(bytes, 0, dist, src.Length, bytes.Length);

    HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
    byte[] inArray = algorithm.ComputeHash(dist);
    return Convert.ToBase64String(inArray);
}



app.Run();
