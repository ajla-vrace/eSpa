﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.SearchObject
{
    public class KorisnikSearchObject : BaseSearchObject
    {
        public bool? IsUlogeIncluded { get; set; }
        public string? Ime { get; set; }
        public string? Prezime { get; set; }
        public string? KorisnickoIme { get; set; }
        public string? Status { get; set; }
        public bool? isZaposlenik { get; set; }
        public bool? isAdmin { get; set; }
    }
}
