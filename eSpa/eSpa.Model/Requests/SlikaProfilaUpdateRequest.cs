using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class SlikaProfilaUpdateRequest
    {
        [Required]
        public string SlikaBase64 { get; set; } = null!;
    }
}
