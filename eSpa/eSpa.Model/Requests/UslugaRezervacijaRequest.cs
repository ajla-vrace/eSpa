using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class UslugaRezervacijaRequest
    {
        public int UslugaId { get; set; }
        public string Naziv { get; set; }
        public string Sifra { get; set; }

        public int BrojRezervacija { get; set; }
    }

}
