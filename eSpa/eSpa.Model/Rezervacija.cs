﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model
{
    public partial class Rezervacija
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public int UslugaId { get; set; }
        public DateTime Datum { get; set; }
        public int TerminId { get; set; }
        public string Status { get; set; } = null!;
        public string? Napomena { get; set; }
        public int ZaposlenikId { get; set; }
        public bool? IsPlaceno { get; set; }
        public int? StatusRezervacijeId { get; set; }
        public StatusRezervacije StatusRezervacije { get; set; }
        public Korisnik Korisnik { get; set; }
        public Usluga Usluga { get; set; }
        public Zaposlenik Zaposlenik { get; set; }
        public Termin Termin { get; set; }

    }
}
