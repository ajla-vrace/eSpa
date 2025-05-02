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

            CreateMap<Database.Uloga, Model.Uloga>();
            CreateMap<Model.Requests.UlogaInsertRequest, Database.Uloga>();
            CreateMap<Model.Requests.UlogaUpdateRequest, Database.Uloga>();

            CreateMap<Database.KorisnikUloga, Model.KorisnikUloga>();
            CreateMap<Model.Requests.KorisnikUlogaInsertRequest, Database.KorisnikUloga>();
            CreateMap<Model.Requests.KorisnikUlogaUpdateRequest, Database.KorisnikUloga>();

            CreateMap<Database.Usluga, Model.Usluga>();
            CreateMap<Model.Requests.UslugaInsertRequest, Database.Usluga>();
            CreateMap<Model.Requests.UslugaUpdateRequest, Database.Usluga>();

            CreateMap<Database.Komentar, Model.Komentar>();
            CreateMap<Model.Requests.KomentarInsertRequest, Database.Komentar>();
            CreateMap<Model.Requests.KomentarUpdateRequest, Database.Komentar>();

            CreateMap<Database.NovostKomentar, Model.NovostKomentar>();
            CreateMap<Model.Requests.NovostKomentarInsertRequest, Database.NovostKomentar>();
            CreateMap<Model.Requests.NovostKomentarUpdateRequest, Database.NovostKomentar>();

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


           // CreateMap<Database.KorisnikUloga, Model.KorisnikUloga>();

           // CreateMap<Database.Uloga, Model.Uloga>();

            // CreateMap<Database.Usluga, Model.Usluga>();

            // Kategorija
            CreateMap<Database.Kategorija, Model.Kategorija>();
            CreateMap<Model.Requests.KategorijaInsertRequest, Database.Kategorija>();
            CreateMap<Model.Requests.KategorijaUpdateRequest, Database.Kategorija>();


            // Zaposlenik
            CreateMap<Database.Zaposlenik, Model.Zaposlenik>();
            CreateMap<Model.Requests.ZaposlenikInsertRequest, Database.Zaposlenik>();
            CreateMap<Model.Requests.ZaposlenikUpdateRequest, Database.Zaposlenik>();

            CreateMap<Database.ZaposlenikSlike, Model.ZaposlenikSlike>();
            CreateMap<Model.Requests.ZaposlenikSlikeInsertRequest, Database.ZaposlenikSlike>();
            CreateMap<Model.Requests.ZaposlenikSlikeUpdateRequest, Database.ZaposlenikSlike>();

            CreateMap<Database.ZaposlenikRecenzija, Model.ZaposlenikRecenzija>();
            CreateMap<Model.Requests.ZaposlenikRecenzijaInsertRequest, Database.ZaposlenikRecenzija>();
            CreateMap<Model.Requests.ZaposlenikRecenzijaUpdateRequest, Database.ZaposlenikRecenzija>();



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
