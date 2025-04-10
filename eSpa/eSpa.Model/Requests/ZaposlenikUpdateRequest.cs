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
        public string? Ime { get; set; }
        public string? Prezime { get; set; }
        public DateTime DatumZaposlenja { get; set; }
        public string Struka { get; set; } = null!;
        public string? Status { get; set; }
        public string? Napomena { get; set; }
        public string? Biografija { get; set; }
        public int? SlikaId { get; set; }
    }
}
