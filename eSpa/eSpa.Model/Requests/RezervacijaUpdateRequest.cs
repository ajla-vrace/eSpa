using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class RezervacijaUpdateRequest
    {
        // public int UslugaId { get; set; }
        //public DateTime Datum { get; set; }
        // public int TerminId { get; set; }
        [Required]
        public int StatusRezervacijeId { get; set; }
    }
}
