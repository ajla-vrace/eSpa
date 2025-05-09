using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.SearchObject
{
    public class NovostInterakcijaSearchObject : BaseSearchObject
    {
        public string? Korisnik { get; set; }
        public string? Novost { get; set; }
    }
}
