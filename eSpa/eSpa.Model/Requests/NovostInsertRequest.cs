using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class NovostInsertRequest
    {
        [Required(AllowEmptyStrings = false)]
        public string Naslov { get; set; } = null!;

        [Required(AllowEmptyStrings = false)]
        [MinLength(100, ErrorMessage = "Sadržaj mora imati minimalno 100 znakova.")]

        public string Sadrzaj { get; set; } = null!;
       // public DateTime Datum { get; set; }
    }
}
