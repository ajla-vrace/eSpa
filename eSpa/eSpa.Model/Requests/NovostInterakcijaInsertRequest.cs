using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class NovostInterakcijaInsertRequest
    {
        [Required(ErrorMessage = "Korisnik Id je obavezan.")]
        public int KorisnikId { get; set; }

        [Required(ErrorMessage = "Novost Id je obavezna.")]
        public int NovostId { get; set; }

        [Required]
        public bool isLiked { get; set; }
    }
}
