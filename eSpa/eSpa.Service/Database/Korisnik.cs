using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class Korisnik
    {
        public Korisnik()
        {
            Favorits = new HashSet<Favorit>();
            Komentars = new HashSet<Komentar>();
            KorisnikUlogas = new HashSet<KorisnikUloga>();
            NovostInterakcijas = new HashSet<NovostInterakcija>();
            NovostKomentars = new HashSet<NovostKomentar>();
            Novosts = new HashSet<Novost>();
            Ocjenas = new HashSet<Ocjena>();
            Rezervacijas = new HashSet<Rezervacija>();
            ZaposlenikRecenzijas = new HashSet<ZaposlenikRecenzija>();
            Zaposleniks = new HashSet<Zaposlenik>();
        }

        public int Id { get; set; }
        public string Ime { get; set; } = null!;
        public string Prezime { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string? Telefon { get; set; }
        public DateTime? DatumRegistracije { get; set; }
        public string KorisnickoIme { get; set; } = null!;
        public string LozinkaHash { get; set; } = null!;
        public string LozinkaSalt { get; set; } = null!;
        public string Status { get; set; } = null!;
        public bool? IsAdmin { get; set; }
        public bool? IsBlokiran { get; set; }
        public bool? IsZaposlenik { get; set; }
        public int? SlikaId { get; set; }

        public virtual SlikaProfila? Slika { get; set; }
        public virtual ICollection<Favorit> Favorits { get; set; }
        public virtual ICollection<Komentar> Komentars { get; set; }
        public virtual ICollection<KorisnikUloga> KorisnikUlogas { get; set; }
        public virtual ICollection<NovostInterakcija> NovostInterakcijas { get; set; }
        public virtual ICollection<NovostKomentar> NovostKomentars { get; set; }
        public virtual ICollection<Novost> Novosts { get; set; }
        public virtual ICollection<Ocjena> Ocjenas { get; set; }
        public virtual ICollection<Rezervacija> Rezervacijas { get; set; }
        public virtual ICollection<ZaposlenikRecenzija> ZaposlenikRecenzijas { get; set; }
        public virtual ICollection<Zaposlenik> Zaposleniks { get; set; }
    }
}
