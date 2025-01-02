using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model
{
    public partial class Rezervacija
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public int UslugaId { get; set; }
        public DateTime Datum { get; set; }
        public int TerminId { get; set; }
        public string Status { get; set; } = null!;

    }
}
