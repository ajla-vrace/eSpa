using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.SearchObject
{
    public class ZaposlenikSearchObject:BaseSearchObject
    {
        public string? Ime { get; set; }
        public string? Prezime { get; set; }
        public string? KorisnickoIme { get; set; }
        public string? Uloga { get; set; }
        public string? Status { get; set; }
        public string? Kategorija { get; set; }
    }
}
