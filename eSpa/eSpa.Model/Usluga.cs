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
        public Kategorija Kategorija { get; set; }
        public byte[]? Slika { get; set; }
        public virtual ICollection<Favorit> Favorits { get; set; } = new List<Favorit>();
        //public virtual ICollection<Ocjena> Ocjenas { get; set; } = new List<Ocjena>();

    }
}
