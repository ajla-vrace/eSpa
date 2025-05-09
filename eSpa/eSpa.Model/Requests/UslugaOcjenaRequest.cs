using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class UslugaOcjenaRequest
    {
        public int UslugaId { get; set; } // ID usluge
        public string Naziv { get; set; } // Naziv usluge
        public string Sifra { get; set; } // Naziv usluge
        public double ProsjecnaOcjena { get; set; } // Prosječna ocjena
    }
}
