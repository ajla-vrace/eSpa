using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class UslugaUpdateRequest
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Naziv je obavezan.")]
        [StringLength(100, MinimumLength = 3, ErrorMessage = "Naziv mora imati između 3 i 100 karaktera.")]
        public string Naziv { get; set; } = null!;

        [Required(AllowEmptyStrings = false, ErrorMessage = "Opis je obavezan.")]
        [StringLength(500, ErrorMessage = "Opis može imati maksimalno 500 karaktera.")]
        public string? Opis { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Cijena je obavezan.")]
        [Range(0.01, 10000.00, ErrorMessage = "Cijena mora biti između 0.01 i 10,000.00.")]
        public decimal Cijena { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Trajanje je obavezan.")]
        [Range(40, 50, ErrorMessage = "Trajanje mora biti između 40 i 50 minuta.")]
        public int Trajanje { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "KategorijaId je obavezan.")]
        [Range(1, int.MaxValue, ErrorMessage = "KategorijaId mora biti validan pozitivan broj.")]
        public int KategorijaId { get; set; }
        public string? SlikaBase64 { get; set; }
    }
}
