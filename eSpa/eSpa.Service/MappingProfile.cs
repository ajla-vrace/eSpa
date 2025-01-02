using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;

namespace eSpa.Service
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<Database.Korisnik, Model.Korisnik>();
            CreateMap<Model.Requests.KorisnikInsertRequest, Database.Korisnik>();
            CreateMap<Model.Requests.KorisnikUpdateRequest, Database.Korisnik>();
           
            CreateMap<Database.Usluga, Model.Usluga>();
            CreateMap<Model.Requests.UslugaInsertRequest, Database.Usluga>();
            CreateMap<Model.Requests.UslugaUpdateRequest, Database.Usluga>();

            CreateMap<Database.Komentar, Model.Komentar>();
            CreateMap<Model.Requests.KomentarInsertRequest, Database.Komentar>();
            CreateMap<Model.Requests.KomentarUpdateRequest, Database.Komentar>();

            CreateMap<Database.Novost, Model.Novost>();
            CreateMap<Model.Requests.NovostInsertRequest, Database.Novost>();
            CreateMap<Model.Requests.NovostUpdateRequest, Database.Novost>();

            CreateMap<Database.Ocjena, Model.Ocjena>();
            CreateMap<Model.Requests.OcjenaInsertRequest, Database.Ocjena>();
            CreateMap<Model.Requests.OcjenaUpdateRequest, Database.Ocjena>();

            CreateMap<Database.Termin, Model.Termin>();
            CreateMap<Model.Requests.TerminInsertRequest, Database.Termin>();
            CreateMap<Model.Requests.TerminUpdateRequest, Database.Termin>();

            CreateMap<Database.Rezervacija, Model.Rezervacija>();
            CreateMap<Model.Requests.RezervacijaInsertRequest, Database.Rezervacija>();
            CreateMap<Model.Requests.RezervacijaUpdateRequest, Database.Rezervacija>();


            CreateMap<Database.KorisnikUloga, Model.KorisnikUloga>();

            CreateMap<Database.Uloga, Model.Uloga>();

           // CreateMap<Database.Usluga, Model.Usluga>();

            // Kategorija
            CreateMap<Database.Kategorija, Model.Kategorija>();

            
            // Zaposlenik
            CreateMap<Database.Zaposlenik, Model.Zaposlenik>();

            // Novost
            //CreateMap<Database.Novost, Model.Novost>();

            // Komentar
           // CreateMap<Database.Komentar, Model.Komentar>();

            // Ocjena
           // CreateMap<Database.Ocjena, Model.Ocjena>();

            // Rezervacija
            //CreateMap<Database.Rezervacija, Model.Rezervacija>();

            // Termin
           // CreateMap<Database.Termin, Model.Termin>();
            
        }
    }

    //public UserProfile()
    //{
    //    CreateMap<User, UserViewModel>();
    //}
}
