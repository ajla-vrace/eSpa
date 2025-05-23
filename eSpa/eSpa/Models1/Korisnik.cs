﻿using System;
using System.Collections.Generic;

namespace eSpa.Models
{
    public partial class Korisnik
    {
        public Korisnik()
        {
            Komentars = new HashSet<Komentar>();
            KorisnikUlogas = new HashSet<KorisnikUloga>();
            Novosts = new HashSet<Novost>();
            Ocjenas = new HashSet<Ocjena>();
            Rezervacijas = new HashSet<Rezervacija>();
            Zaposleniks = new HashSet<Zaposlenik>();
        }

        public int Id { get; set; }
        public string Ime { get; set; } = null!;
        public string Prezime { get; set; } = null!;
        public string Email { get; set; } = null!;
        public bool IsAdmin { get; set; }
        public bool IsBlokiran { get; set; }
        public string? Telefon { get; set; }
        public DateTime? DatumRegistracije { get; set; }
        public string KorisnickoIme { get; set; } = null!;
        public string LozinkaHash { get; set; } = null!;
        public string LozinkaSalt { get; set; } = null!;
        public string Status { get; set; } = null!;

        public virtual ICollection<Komentar> Komentars { get; set; }
        public virtual ICollection<KorisnikUloga> KorisnikUlogas { get; set; }
        public virtual ICollection<Novost> Novosts { get; set; }
        public virtual ICollection<Ocjena> Ocjenas { get; set; }
        public virtual ICollection<Rezervacija> Rezervacijas { get; set; }
        public virtual ICollection<Zaposlenik> Zaposleniks { get; set; }
    }
}
