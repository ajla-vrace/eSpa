using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class ZaposlenikRecenzija
    {
        public int Id { get; set; }
        public string? Komentar { get; set; }
        public int Ocjena { get; set; }
        public DateTime DatumKreiranja { get; set; }
        public int? ZaposlenikId { get; set; }
        public int? KorisnikId { get; set; }

        public virtual Korisnik? Korisnik { get; set; }
        public virtual Zaposlenik? Zaposlenik { get; set; }
    }
}
