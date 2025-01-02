using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class Uloga
    {
       
        public int Id { get; set; }
        public string Naziv { get; set; } = null!;

        public virtual ICollection<KorisnikUloga> KorisnikUlogas { get; set; }
    }
}
