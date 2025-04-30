using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model
{
    public partial class Novost
    {
        public int Id { get; set; }
        public string Naslov { get; set; } = null!;
        public string Sadrzaj { get; set; } = null!;
        public DateTime DatumKreiranja { get; set; }
        public int? AutorId { get; set; }
        public string? Status { get; set; }
        public Korisnik Autor { get; set; }
        public byte[]? Slika { get; set; }
    }
}
