using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class KomentarUpdateRequest
    {
        [Required(ErrorMessage = "Tekst komentara je obavezan.")]
        [StringLength(1000, ErrorMessage = "Tekst komentara ne smije biti duži od 1000 karaktera.")]
        public string Tekst { get; set; } = null!;
        //public DateTime Datum { get; set; }
    }
}
