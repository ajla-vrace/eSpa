using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model
{
    public partial class Korisnik
    {
        public int Id { get; set; }

        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string? Email { get; set; }

        public string? Telefon { get; set; }

        public string KorisnickoIme { get; set; } = null!;

        public bool? Status { get; set; }
        //ovdje promjena isto
        public virtual ICollection<KorisnikUloga> KorisnikUloges { get; } = new List<KorisnikUloga>();
    }
}
