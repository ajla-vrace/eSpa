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
        public int? TerminId { get; set; }
        public string? Zaposlenik { get; set; }
        public string? Kategorija { get; set; }
        public DateTime? Datum { get; set; }

        public string? Status { get; set; }
    }
}
