using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class NovostKomentar
    {
        public int Id { get; set; }
        public string Sadrzaj { get; set; } = null!;
        public DateTime DatumKreiranja { get; set; }
        public int NovostId { get; set; }
        public int KorisnikId { get; set; }

        public virtual Korisnik Korisnik { get; set; } = null!;
        public virtual Novost Novost { get; set; } = null!;
    }
}
