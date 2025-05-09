using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class Novost
    {
        public Novost()
        {
            NovostInterakcijas = new HashSet<NovostInterakcija>();
            NovostKomentars = new HashSet<NovostKomentar>();
        }

        public int Id { get; set; }
        public string Naslov { get; set; } = null!;
        public string Sadrzaj { get; set; } = null!;
        public DateTime? DatumKreiranja { get; set; }
        public int AutorId { get; set; }
        public string? Status { get; set; }
        public byte[]? Slika { get; set; }

        public virtual Korisnik Autor { get; set; } = null!;
        public virtual ICollection<NovostInterakcija> NovostInterakcijas { get; set; }
        public virtual ICollection<NovostKomentar> NovostKomentars { get; set; }
    }
}
