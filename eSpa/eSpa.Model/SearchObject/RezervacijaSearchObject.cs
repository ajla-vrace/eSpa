using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.SearchObject
{
    public class RezervacijaSearchObject:BaseSearchObject
    {
        public string? Korisnik { get; set; }

        public string? Usluga { get; set; }

        public string? Status { get; set; }
    }
}
