using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model
{
    public partial class Korisnik
    {
        /* public int Id { get; set; }

         public string Ime { get; set; } = null!;

         public string Prezime { get; set; } = null!;

         public string? Email { get; set; }

         public string? Telefon { get; set; }
         public DateTime DatumRegistracije { get; set; }

         public string KorisnickoIme { get; set; } = null!;
         public string LozinkaHash { get; set; } = null!;
         public string LozinkaSalt { get; set; } = null!;
         public string? Status { get; set; }
         public bool? IsAdmin { get; set; }
         public bool? IsBlokiran { get; set; }
         public bool? IsZaposlenik { get; set; }*/
        //public bool? IsBlokiran { get; set; }
        //ovdje promjena isto
        /*public int Id { get; set; }
        public string Ime { get; set; } = null!;
        public string Prezime { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string? Telefon { get; set; }
        public DateTime? DatumRegistracije { get; set; }
        public string KorisnickoIme { get; set; } = null!;
        //public string LozinkaHash { get; set; } = null!;
        //public string LozinkaSalt { get; set; } = null!;
        public string Status { get; set; } = null!;
        public bool? IsAdmin { get; set; }
        public bool? IsBlokiran { get; set; }
        public bool? IsZaposlenik { get; set; }
        public virtual ICollection<KorisnikUloga> KorisnikUloges { get; set; } = new List<KorisnikUloga>();
    */

        public int Id { get; set; }
        public string Ime { get; set; } = null!;
        public string Prezime { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string? Telefon { get; set; }
        public DateTime? DatumRegistracije { get; set; }
        public string KorisnickoIme { get; set; } = null!;
        public string Status { get; set; } = null!;
        public bool? IsAdmin { get; set; }
        public string LozinkaHash { get; set; } = null!;
        public string LozinkaSalt { get; set; } = null!;
        public bool? IsBlokiran { get; set; }
        public bool? IsZaposlenik { get; set; }

        // Ovdje ne bi trebali da budu kolekcije, jer model obično sadrži samo podatke koje ćemo poslati klijentima (npr. DTO)
        // Kolekcije tipa ICollection<Komentar>, ICollection<KorisnikUloga> itd. biće obuhvaćene posebnim modelima i/ili u servisima.
        public virtual ICollection<KorisnikUloga> KorisnikUlogas { get; set; } = new List<KorisnikUloga>();
        //public virtual ICollection<KorisnikUloga> KorisnikUloges { get; set; } = new HashSet<KorisnikUloga>();


    }
}
