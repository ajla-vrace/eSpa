using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model
{
    public partial class Uloga
    {
        public int Id { get; set; }

        public string Naziv { get; set; } = null!;
        //public virtual ICollection<KorisnikUloga> KorisnikUloges { get; set; } = new List<KorisnikUloga>();


        //public string? Opis { get; set; }
    }
}
