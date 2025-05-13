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
        [Required(AllowEmptyStrings = false, ErrorMessage = "KorisnikId je obavezan.")]
        public int KorisnikId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "DatumZaposlenja je obavezan.")]
        public DateTime DatumZaposlenja { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Struka je obavezan.")]
        public string Struka { get; set; } = null!;
        [Required(AllowEmptyStrings = false, ErrorMessage = "Status je obavezan.")]
        public string? Status { get; set; } = "Aktivan";
        public string? Napomena { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Biografija je obavezan.")]
        public string? Biografija { get; set; }
        public int? SlikaId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "KategorijaId je obavezan.")]
        public int KategorijaId { get; set; }
    }
}
