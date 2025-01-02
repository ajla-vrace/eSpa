using eSpa.Model;
using eSpa.Model.SearchObject;
using eSpa.Service.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Service
{
        public interface IKategorijaService: IService<Model.Kategorija,KategorijaSearchObject>
        {
        //jer sad nasljedjuje iservice interfejs
        //Task<List<Model.Kategorija>> Get();

        //proba pokusaj
        //Model.Kategorija Insert();
        //Model.Kategorija Update();


        //ovo je nesto bezveze, proba
            /*Task<IEnumerable<Database.Kategorija>> GetAll();
            Task<Database.Kategorija> GetById(int id);
            Task<Database.Kategorija> AddKategorija(Database.Kategorija novaKategorija);
            Task<Database.Kategorija> UpdateKategorija(int id, Database.Kategorija kategorija);
            Task<bool> DeleteKategorija(int id);*/
        }

}
