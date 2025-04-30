using eSpa.Model;
using eSpa.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Service
{
    
        public interface IKorisniciService :ICRUDService<Model.Korisnik,Model.SearchObject.KorisnikSearchObject,Model.Requests.KorisnikInsertRequest,Model.Requests.KorisnikUpdateRequest>
        {
            public Task<Model.Korisnik> Login(string username, string password);
        Task ChangePasswordAsync(ChangePasswordRequest model);
    }
    
}
