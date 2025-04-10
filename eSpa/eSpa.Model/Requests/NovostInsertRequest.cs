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
        [MinLength(10, ErrorMessage = "Sadržaj mora imati minimalno 10 znakova.")]

        public string Sadrzaj { get; set; } = null!;
        //public string? Status { get; set; }

        //public int? AutorID { get; set; }
        // public DateTime Datum { get; set; }
    }
}
