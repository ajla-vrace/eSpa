using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class KorisnikUpdateRequest
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Ime je obavezan.")]
        public string Ime { get; set; } = null!;
        [Required(AllowEmptyStrings = false, ErrorMessage = "Prezime je obavezan.")]
        public string Prezime { get; set; } = null!;
        [Required(AllowEmptyStrings = false, ErrorMessage = "Email je obavezan.")]
        public string? Email { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Telefon je obavezan.")]
        public string? Telefon { get; set; }
        public bool? IsAdmin { get; set; }
        public string? Status { get; set; }
        public bool? IsBlokiran { get; set; }
        public int? SlikaId { get; set; }
    }
}
