using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class Kategorija
    {
        public Kategorija()
        {
            Uslugas = new HashSet<Usluga>();
            Zaposleniks = new HashSet<Zaposlenik>();
        }

        public int Id { get; set; }
        public string Naziv { get; set; } = null!;

        public virtual ICollection<Usluga> Uslugas { get; set; }
        public virtual ICollection<Zaposlenik> Zaposleniks { get; set; }
    }
}
