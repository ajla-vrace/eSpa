using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model
{
    public partial class Usluga
    {
        public int Id { get; set; }
        public string Naziv { get; set; } = null!;
        public string? Opis { get; set; }
        public decimal Cijena { get; set; }
        public string Trajanje { get; set; } = null!;
        public int KategorijaId { get; set; }
    }
}
