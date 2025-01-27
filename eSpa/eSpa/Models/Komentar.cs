using System;
using System.Collections.Generic;

namespace eSpa.Models
{
    public partial class Komentar
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public int UslugaId { get; set; }
        public string Tekst { get; set; } = null!;
        public DateTime Datum { get; set; }
        public bool? Preporuka { get; set; }

        public virtual Korisnik Korisnik { get; set; } = null!;
        public virtual Usluga Usluga { get; set; } = null!;
    }
}
