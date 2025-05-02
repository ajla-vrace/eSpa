using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class ZaposlenikRecenzijaUpdateRequest
    {
        public string? Komentar { get; set; }
        public int Ocjena { get; set; }
    }
}
