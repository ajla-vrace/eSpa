﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class NovostKomentarInsertRequest
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Korisnikid je obavezan.")]
        public int KorisnikId { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "NovostId je obavezan.")]
        public int NovostId { get; set; }

        [Required(ErrorMessage = "Tekst komentara je obavezan.")]
        [StringLength(1000, ErrorMessage = "Tekst komentara ne smije biti duži od 1000 karaktera.")]
        public string Sadrzaj { get; set; } = null!;
    }
}
