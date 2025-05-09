using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model
{
    public class Favorit
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public int UslugaId { get; set; }
        public bool? IsFavorit { get; set; }
        public DateTime Datum { get; set; }

        //public Korisnik Korisnik { get; set; }
        //public Usluga Usluga { get; set; } 
    }
}
