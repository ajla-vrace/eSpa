﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class FavoritUpdateRequest
    {

        [Required(ErrorMessage = "Polje isFavorit je obavezno.")]
        public bool? isFavorit { get; set; }
    }
}
