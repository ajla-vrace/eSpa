using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model
{
    public class NovostKomentar
    {
        public int Id { get; set; }
        public string Sadrzaj { get; set; } = null!;
        public DateTime DatumKreiranja { get; set; }
        public int NovostId { get; set; }
        public int KorisnikId { get; set; }

        public  Korisnik Korisnik { get; set; }
        public  Novost Novost { get; set; }
    }
}
