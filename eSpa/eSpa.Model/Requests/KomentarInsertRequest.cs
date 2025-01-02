using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class KomentarInsertRequest
    {
        // public int KorisnikId { get; set; }
        //public int UslugaId { get; set; }
        //public string Tekst { get; set; } = null!;
        //public DateTime Datum { get; set; }
        [Required(ErrorMessage = "Korisnik Id je obavezan.")]
        public int KorisnikId { get; set; }

        [Required(ErrorMessage = "Usluga Id je obavezna.")]
        public int UslugaId { get; set; }

        [Required(ErrorMessage = "Tekst komentara je obavezan.")]
        [StringLength(1000, ErrorMessage = "Tekst komentara ne smije biti duži od 1000 karaktera.")]
        public string Tekst { get; set; } = null!;

       /* [Required(ErrorMessage = "Datum je obavezan.")]
        public DateTime Datum { get; set; }*/
    }
}
