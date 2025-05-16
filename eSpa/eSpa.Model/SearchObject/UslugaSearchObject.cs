using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.SearchObject
{
    public class UslugaSearchObject : BaseSearchObject
    {
        public string? Naziv { get; set; }
        public string? Naziv1 { get; set; }
        public int? Cijena { get; set; }
        public string? Trajanje { get; set; }
        public string? Kategorija { get; set; }
        //public string? Sifra { get; set; }
    }
}
