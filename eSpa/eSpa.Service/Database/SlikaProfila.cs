using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class SlikaProfila
    {
        public SlikaProfila()
        {
            Korisniks = new HashSet<Korisnik>();
        }

        public int Id { get; set; }
        public string? Naziv { get; set; }
        public byte[]? Slika { get; set; }
        public string? Tip { get; set; }
        public DateTime? DatumPostavljanja { get; set; }

        public virtual ICollection<Korisnik> Korisniks { get; set; }
    }
}
