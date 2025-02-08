using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class ZaposlenikUpdateRequest
    {
        public DateTime DatumZaposlenja { get; set; }
        public string Struka { get; set; } = null!;
        public string? Status { get; set; } = "Aktivan";
        public string? Napomena { get; set; }
    }
}
