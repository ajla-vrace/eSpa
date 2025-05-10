using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class Rezervacija
    {
        public int Id { get; set; }
        public int? KorisnikId { get; set; }
        public int? UslugaId { get; set; }
        public DateTime Datum { get; set; }
        public int? TerminId { get; set; }
        public string Status { get; set; } = null!;
        public string? Napomena { get; set; }
        public int? ZaposlenikId { get; set; }
        public bool? IsPlaceno { get; set; }
        public int? StatusRezervacijeId { get; set; }

        public virtual Korisnik? Korisnik { get; set; }
        public virtual StatusRezervacije? StatusRezervacije { get; set; }
        public virtual Termin? Termin { get; set; }
        public virtual Usluga? Usluga { get; set; }
        public virtual Zaposlenik? Zaposlenik { get; set; }
    }
}
