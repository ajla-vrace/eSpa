using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model.Requests
{
    public class ChangePasswordRequest
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Id je obavezan.")]
        public int Id { get; set; }
        public string StariPassword { get; set; }
        //[Compare("PasswordPotvrda", ErrorMessage = "Passwords do not match.")]
        public string NoviPassword { get; set; }
       // [Compare("Password", ErrorMessage = "Passwords do not match.")]
        public string PotvrdaPassword { get; set; }
    }

}
