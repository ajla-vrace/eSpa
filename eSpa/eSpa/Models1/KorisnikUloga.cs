using System;
using System.Collections.Generic;

namespace eSpa.Models
{
    public partial class KorisnikUloga
    {
        public int KorisnikulogaId { get; set; }
        public int KorisnikId { get; set; }
        public int UlogaId { get; set; }
        public DateTime? DatumDodele { get; set; }

        public virtual Korisnik Korisnik { get; set; } = null!;
        public virtual Uloga Uloga { get; set; } = null!;
    }
}
