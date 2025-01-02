using System;
using System.Collections.Generic;

namespace eSpa.Service.Database
{
    public partial class Zaposlenik
    {
        public int Id { get; set; }
        public string Ime { get; set; } = null!;
        public string Prezime { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string? Telefon { get; set; }
        public DateTime DatumZaposlenja { get; set; }
    }
}
