using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class StatusRezervacije
    {
        public StatusRezervacije()
        {
            Rezervacijas = new HashSet<Rezervacija>();
        }

        public int Id { get; set; }
        public string Naziv { get; set; } = null!;
        public string? Opis { get; set; }

        public virtual ICollection<Rezervacija> Rezervacijas { get; set; }
    }
}
