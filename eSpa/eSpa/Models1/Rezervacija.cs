﻿using System;
using System.Collections.Generic;

namespace eSpa.Models
{
    public partial class Rezervacija
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public int UslugaId { get; set; }
        public DateTime Datum { get; set; }
        public int TerminId { get; set; }
        public string Status { get; set; } = null!;

        public virtual Korisnik Korisnik { get; set; } = null!;
        public virtual Termin Termin { get; set; } = null!;
        public virtual Usluga Usluga { get; set; } = null!;
    }
}
