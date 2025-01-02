using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model
{
    public partial class KorisnikUloga
    {
        public int KorisnikUlogaId { get; set; }

        public int KorisnikId { get; set; }

        public int UlogaId { get; set; }

        public DateTime DatumIzmjene { get; set; }

        public virtual Uloga Uloga { get; set; } = null!;
        public virtual Korisnik Korisnik { get; set; } = null!; //sad dodano
    }
}
