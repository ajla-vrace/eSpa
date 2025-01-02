using System;
using System.Collections.Generic;

namespace eSpa.Models
{
    public partial class Kategorija
    {
        public Kategorija()
        {
            Uslugas = new HashSet<Usluga>();
        }

        public int Id { get; set; }
        public string Naziv { get; set; } = null!;

        public virtual ICollection<Usluga> Uslugas { get; set; }
    }
}
