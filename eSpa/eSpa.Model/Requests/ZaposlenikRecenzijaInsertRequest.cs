using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class ZaposlenikRecenzijaInsertRequest
    {
        //[Required(AllowEmptyStrings = false, ErrorMessage = "Korisnikid je obavezan.")]
        public string? Komentar { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Ocjena je obavezan.")]
        public int Ocjena { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "ZaposleniId je obavezan.")]
        public int ZaposlenikId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Korisnikid je obavezan.")]
        public int KorisnikId { get; set; }

    }
}
