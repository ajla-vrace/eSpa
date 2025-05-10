using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class NovostInterakcija
    {
        public int Id { get; set; }
        public int? NovostId { get; set; }
        public int? KorisnikId { get; set; }
        public bool IsLiked { get; set; }
        public DateTime Datum { get; set; }

        public virtual Korisnik? Korisnik { get; set; }
        public virtual Novost? Novost { get; set; }
    }
}
