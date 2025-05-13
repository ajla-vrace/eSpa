using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class KorisnikUlogaInsertRequest
    {
        //public int KorisnikUlogaId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "KorinikId je obavezan.")]
        public int KorisnikId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Ulogaid je obavezan.")]
        public int UlogaId { get; set; }

       // public DateTime DatumIzmjene { get; set; }
    }
}
