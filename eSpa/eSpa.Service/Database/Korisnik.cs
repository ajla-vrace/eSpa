using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class Korisnik
    {
      

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

        public virtual ICollection<Komentar> Komentars { get; set; }
        public virtual ICollection<KorisnikUloga> KorisnikUlogas { get; set; }
        public virtual ICollection<Ocjena> Ocjenas { get; set; }
        public virtual ICollection<Rezervacija> Rezervacijas { get; set; }
    }
}
