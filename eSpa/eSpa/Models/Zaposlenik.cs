using System;
using System.Collections.Generic;

namespace eSpa.Models
{
    public partial class Zaposlenik
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public DateTime DatumZaposlenja { get; set; }
        public string Struka { get; set; } = null!;
        public string? Status { get; set; }
        public string? Napomena { get; set; }

        public virtual Korisnik Korisnik { get; set; } = null!;
    }
}
