using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class Zaposlenik
    {
        public Zaposlenik()
        {
            Rezervacijas = new HashSet<Rezervacija>();
            ZaposlenikRecenzijas = new HashSet<ZaposlenikRecenzija>();
        }

        public int Id { get; set; }
        public int? KorisnikId { get; set; }
        public DateTime DatumZaposlenja { get; set; }
        public string Struka { get; set; } = null!;
        public string? Status { get; set; }
        public string? Napomena { get; set; }
        public string? Biografija { get; set; }
        public int? SlikaId { get; set; }
        public int? KategorijaId { get; set; }

        public virtual Kategorija? Kategorija { get; set; }
        public virtual Korisnik? Korisnik { get; set; }
        public virtual ICollection<Rezervacija> Rezervacijas { get; set; }
        public virtual ICollection<ZaposlenikRecenzija> ZaposlenikRecenzijas { get; set; }
    }
}
