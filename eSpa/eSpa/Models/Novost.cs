using System;
using System.Collections.Generic;

namespace eSpa.Models
{
    public partial class Novost
    {
        public int Id { get; set; }
        public string Naslov { get; set; } = null!;
        public string Sadrzaj { get; set; } = null!;
        public DateTime Datum { get; set; }
    }
}
