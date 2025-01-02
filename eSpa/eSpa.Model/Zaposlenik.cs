using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model
{
    public partial class Zaposlenik
    {
        public int Id { get; set; }
        public string Ime { get; set; } = null!;
        public string Prezime { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string? Telefon { get; set; }
        public DateTime DatumZaposlenja { get; set; }
    }
}
