using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class KorisnikUloga
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public int UlogaId { get; set; }
        public DateTime? DatumDodele { get; set; }

        public virtual Korisnik Korisnik { get; set; } = null!;
        public virtual Uloga Uloga { get; set; } = null!;
    }
}
