using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model
{
    public class NovostInterakcija
    {
        public int Id { get; set; }
        public int NovostId { get; set; }
        public int KorisnikId { get; set; }
        public bool IsLiked { get; set; }
        public DateTime Datum { get; set; }

        //public virtual Korisnik Korisnik { get; set; } = null!;
        //public virtual Novost Novost { get; set; } = null!;
    }
}
