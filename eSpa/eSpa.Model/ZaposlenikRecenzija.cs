using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model
{
    public class ZaposlenikRecenzija
    {
        public int Id { get; set; }
        public string? Komentar { get; set; }
        public int Ocjena { get; set; }
        public DateTime DatumKreiranja { get; set; }
        public int ZaposlenikId { get; set; }
        public int KorisnikId { get; set; }

        public  Korisnik Korisnik { get; set; }
        public  Zaposlenik Zaposlenik { get; set; } 
    }
}
