using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model
{
    public partial class ZaposlenikSlike
    {
        public int Id { get; set; }
        public string? Naziv { get; set; }
        public byte[]? Slika { get; set; }
        public string? Tip { get; set; }
        public DateTime? DatumPostavljanja { get; set; }

    }
}
