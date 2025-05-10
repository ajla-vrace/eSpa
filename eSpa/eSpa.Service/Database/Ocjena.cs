using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class Ocjena
    {
        public int Id { get; set; }
        public int? KorisnikId { get; set; }
        public int? UslugaId { get; set; }
        public int Ocjena1 { get; set; }
        public DateTime Datum { get; set; }

        public virtual Korisnik? Korisnik { get; set; }
        public virtual Usluga? Usluga { get; set; }
    }
}
