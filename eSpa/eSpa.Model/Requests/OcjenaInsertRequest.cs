using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class OcjenaInsertRequest
    {
        [Required]
        public int KorisnikId { get; set; }
        [Required]
        public int UslugaId { get; set; }
        [Required]
        [Range(1, 5, ErrorMessage = "Ocjena mora biti između 1 i 5.")]
        public int Ocjena1 { get; set; }
        //public DateTime Datum { get; set; }
    }
}
