using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class Kategorija
    {
       
        public int Id { get; set; }
        public string Naziv { get; set; } = null!;

        public virtual ICollection<Usluga> Uslugas { get; set; }
    }
}
