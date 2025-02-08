using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class TerminUpdateRequest
    {
         [Required]
         [RegularExpression(@"^([01]\d|2[0-3]):[0-5]\d$", ErrorMessage = "Vrijeme mora biti u formatu 09:00.")]

         public string Pocetak { get; set; }
         [Required]
         [RegularExpression(@"^([01]\d|2[0-3]):[0-5]\d$", ErrorMessage = "Vrijeme mora biti u formatu 09:00.")]

         public string Kraj { get; set; }

    }
}
