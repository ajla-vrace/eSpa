using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class FavoritInsertRequest
    {
        [Required(ErrorMessage = "Korisnik Id je obavezan.")]
        public int KorisnikId { get; set; }

        [Required(ErrorMessage = "Usluga Id je obavezna.")]
        public int UslugaId { get; set; }

        [Required(ErrorMessage = "Polje isFavorit je obavezno.")]
        public bool? isFavorit { get; set; }
    }
}
