using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model
{
    public partial  class Komentar
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public int UslugaId { get; set; }
        public string Tekst { get; set; } = null!;
        public DateTime Datum { get; set; }

    }

}
