using System;
using System.Collections.Generic;

namespace eSpa.Models
{
    public partial class Uloga
    {
        public Uloga()
        {
            KorisnikUlogas = new HashSet<KorisnikUloga>();
        }

        public int Id { get; set; }
        public string Naziv { get; set; } = null!;

        public virtual ICollection<KorisnikUloga> KorisnikUlogas { get; set; }
    }
}
