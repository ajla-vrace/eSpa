using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class UslugaInsertRequest
    {
        //[Required]
        //public string Naziv { get; set; } = null!;

        //[Required]
        //public string? Opis { get; set; }
        //[Required]
        //public decimal Cijena { get; set; }
        //[Required]
        //public string Trajanje { get; set; } = null!;
        //[Required]
        //public int KategorijaId { get; set; }
        [Required]
        [StringLength(100, MinimumLength = 3, ErrorMessage = "Naziv mora imati između 3 i 100 karaktera.")]
        public string Naziv { get; set; } = null!;

        [Required]
        [StringLength(500, ErrorMessage = "Opis može imati maksimalno 500 karaktera.")]
        public string? Opis { get; set; }

        [Required]
        [Range(10.00, 500.00, ErrorMessage = "Cijena mora biti između 10 i 500")]
        public decimal Cijena { get; set; }

        [Required]
        [Range(40, 50, ErrorMessage = "Trajanje mora biti između 40 i 50 minuta.")]
        public int Trajanje { get; set; }

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "KategorijaId mora biti validan pozitivan broj.")]
        public int KategorijaId { get; set; }
    }
}
