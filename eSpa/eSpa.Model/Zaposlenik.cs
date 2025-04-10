using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model
{
    public partial class Zaposlenik
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public DateTime DatumZaposlenja { get; set; }
        public string Struka { get; set; } = null!;
        public string? Status { get; set; }
        public string? Napomena { get; set; }
        public string? Biografija { get; set; }
        public int? SlikaId { get; set; }

        public Korisnik Korisnik { get; set; }
        public ZaposlenikSlike Slika { get; set; }
    }
}
