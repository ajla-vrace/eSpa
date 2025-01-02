using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Model
{
    public partial class Ocjena
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public int UslugaId { get; set; }
        public int Ocjena1 { get; set; }
        public DateTime Datum { get; set; }
    }
}
