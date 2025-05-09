using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class SlikaProfilaInsertRequest
    {
        public string Naziv { get; set; } = null!;
        public string SlikaBase64 { get; set; } = null!;
        public string Tip { get; set; } = null!;
    }
}
