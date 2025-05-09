using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class Usluga
    {
        public Usluga()
        {
            Favorits = new HashSet<Favorit>();
            Komentars = new HashSet<Komentar>();
            Ocjenas = new HashSet<Ocjena>();
            Rezervacijas = new HashSet<Rezervacija>();
        }

        public int Id { get; set; }
        public string Naziv { get; set; } = null!;
        public string? Opis { get; set; }
        public decimal Cijena { get; set; }
        public string Trajanje { get; set; } = null!;
        public int KategorijaId { get; set; }
        public byte[]? Slika { get; set; }

        public virtual Kategorija Kategorija { get; set; } = null!;
        public virtual ICollection<Favorit> Favorits { get; set; }
        public virtual ICollection<Komentar> Komentars { get; set; }
        public virtual ICollection<Ocjena> Ocjenas { get; set; }
        public virtual ICollection<Rezervacija> Rezervacijas { get; set; }
    }
}
