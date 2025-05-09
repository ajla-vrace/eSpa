using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class ZaposlenikInsertRequest
    {
        // public int KorisnikId { get; set; }
        //public int UslugaId { get; set; }
        //public string Tekst { get; set; } = null!;
        //public DateTime Datum { get; set; }
        [Required(ErrorMessage = "Korisnik Id je obavezan.")]
        public int KorisnikId { get; set; }

        public DateTime DatumZaposlenja { get; set; }
        public string Struka { get; set; } = null!;
        public string? Status { get; set; } = "Aktivan";
        public string? Napomena { get; set; }
        public string? Biografija { get; set; }
        public int? SlikaId { get; set; }
        public int KategorijaId { get; set; }
    }
}
