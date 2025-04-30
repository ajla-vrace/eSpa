using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class Novost
    {
        public int Id { get; set; }
        public string Naslov { get; set; } = null!;
        public string Sadrzaj { get; set; } = null!;
        public DateTime? DatumKreiranja { get; set; }
        public int AutorId { get; set; }
        public string? Status { get; set; }
        public byte[]? Slika { get; set; }

        public virtual Korisnik Autor { get; set; } = null!;
    }
}
