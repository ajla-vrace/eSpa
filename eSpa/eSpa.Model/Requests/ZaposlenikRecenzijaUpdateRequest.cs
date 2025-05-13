using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class ZaposlenikRecenzijaUpdateRequest
    {
        public string? Komentar { get; set; }
        //[Required(AllowEmptyStrings = false, ErrorMessage = "Ocjena je obavezan.")]
        public int Ocjena { get; set; }
    }
}
