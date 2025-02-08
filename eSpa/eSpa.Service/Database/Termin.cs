using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class Termin
    {
        public Termin()
        {
            Rezervacijas = new HashSet<Rezervacija>();
        }

        public int Id { get; set; }
        public TimeSpan Pocetak { get; set; }
        public TimeSpan Kraj { get; set; }

        public virtual ICollection<Rezervacija> Rezervacijas { get; set; }
    }
}
