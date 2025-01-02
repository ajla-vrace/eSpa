using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class KategorijaUpdateRequest
    {

        [Required(AllowEmptyStrings = false, ErrorMessage = "Naziv kategorije je obavezan.")]
        [StringLength(50, ErrorMessage = "Naziv kategorije ne sme biti duži od 50 karaktera.")]
        public string Naziv { get; set; }
    }
}
