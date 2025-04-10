using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class ZaposlenikSlike
    {
        public ZaposlenikSlike()
        {
            Zaposleniks = new HashSet<Zaposlenik>();
        }

        public int Id { get; set; }
        public string? Naziv { get; set; }
        public byte[]? Slika { get; set; }
        public string? Tip { get; set; }
        public DateTime? DatumPostavljanja { get; set; }

        public virtual ICollection<Zaposlenik> Zaposleniks { get; set; }
    }
}
