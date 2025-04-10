//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
//using System.Threading.Tasks;

//namespace eSpa.Model.Requests
//{
//    public class RezervacijaInsertRequest
//    {
//        public int KorisnikId { get; set; }
//        public int UslugaId { get; set; }
//        public DateTime Datum { get; set; }
//        public int TerminId { get; set; }
//       // public string Status { get; set; } = null!;
//    }
//}
using System;
using System.ComponentModel.DataAnnotations;

namespace eSpa.Model.Requests
{
    public class RezervacijaInsertRequest
    {
        [Required(ErrorMessage = "Korisnik ID je obavezan.")]
        public int KorisnikId { get; set; }

        [Required(ErrorMessage = "Usluga ID je obavezan.")]
        public int UslugaId { get; set; }

        [Required(ErrorMessage = "Datum je obavezan.")]
        [DataType(DataType.Date, ErrorMessage = "Datum mora biti validan datum.")]
        //[FutureDate(ErrorMessage = "Datum rezervacije ne može biti u prošlosti.")]
        public DateTime Datum { get; set; }

        [Required(ErrorMessage = "Termin ID je obavezan.")]
        public int TerminId { get; set; }

        // Pošto je status automatski postavljen na 'Aktivna' u bazi, nije potrebno unositi ga prilikom kreiranja rezervacije
    }

    // Custom validacija za datum, kako bi se osiguralo da datum nije u prošlosti
    public class FutureDateAttribute : ValidationAttribute
    {
        public override bool IsValid(object value)
        {
            if (value is DateTime dateTime)
            {
                return dateTime >= DateTime.Now; // Proverava da datum nije u prošlosti
            }
            return false;
        }
    }
}
