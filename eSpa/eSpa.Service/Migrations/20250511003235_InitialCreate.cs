using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eSpa.Service.Migrations
{
    public partial class InitialCreate : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Kategorija",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Kategorija", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "SlikaProfila",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    Tip = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    DatumPostavljanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SlikaProfila", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "StatusRezervacije",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StatusRezervacije", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Termin",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Pocetak = table.Column<TimeSpan>(type: "time", nullable: false),
                    Kraj = table.Column<TimeSpan>(type: "time", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Termin", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Uloga",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Uloga", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Usluga",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Cijena = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    Trajanje = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    KategorijaId = table.Column<int>(type: "int", nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Usluga", x => x.Id);
                    table.ForeignKey(
                        name: "FK__Usluga__Kategori__34C8D9D1",
                        column: x => x.KategorijaId,
                        principalTable: "Kategorija",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Korisnik",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Prezime = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Telefon = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    DatumRegistracije = table.Column<DateTime>(type: "datetime", nullable: true),
                    KorisnickoIme = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    LozinkaHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LozinkaSalt = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Status = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    IsAdmin = table.Column<bool>(type: "bit", nullable: true),
                    IsBlokiran = table.Column<bool>(type: "bit", nullable: true),
                    IsZaposlenik = table.Column<bool>(type: "bit", nullable: true),
                    SlikaId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Korisnik", x => x.Id);
                    table.ForeignKey(
                        name: "FK__Korisnik__SlikaI__2A4B4B5E",
                        column: x => x.SlikaId,
                        principalTable: "SlikaProfila",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Favorit",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: true),
                    UslugaId = table.Column<int>(type: "int", nullable: true),
                    IsFavorit = table.Column<bool>(type: "bit", nullable: true),
                    Datum = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Favorit", x => x.Id);
                    table.ForeignKey(
                        name: "FK__Favorit__Korisni__37A5467C",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK__Favorit__UslugaI__38996AB5",
                        column: x => x.UslugaId,
                        principalTable: "Usluga",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Komentar",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: true),
                    UslugaId = table.Column<int>(type: "int", nullable: true),
                    Tekst = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Datum = table.Column<DateTime>(type: "datetime", nullable: false),
                    Preporuka = table.Column<bool>(type: "bit", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Komentar", x => x.Id);
                    table.ForeignKey(
                        name: "FK__Komentar__Korisn__3B75D760",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK__Komentar__Usluga__3C69FB99",
                        column: x => x.UslugaId,
                        principalTable: "Usluga",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "KorisnikUloga",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: true),
                    UlogaId = table.Column<int>(type: "int", nullable: true),
                    DatumDodele = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KorisnikUloga", x => x.Id);
                    table.ForeignKey(
                        name: "FK__KorisnikU__Koris__49C3F6B7",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK__KorisnikU__Uloga__4AB81AF0",
                        column: x => x.UlogaId,
                        principalTable: "Uloga",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Novost",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naslov = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime", nullable: true),
                    AutorId = table.Column<int>(type: "int", nullable: true),
                    Status = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Novost", x => x.Id);
                    table.ForeignKey(
                        name: "FK__Novost__AutorId__4D94879B",
                        column: x => x.AutorId,
                        principalTable: "Korisnik",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Ocjena",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: true),
                    UslugaId = table.Column<int>(type: "int", nullable: true),
                    Ocjena1 = table.Column<int>(type: "int", nullable: false),
                    Datum = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Ocjena", x => x.Id);
                    table.ForeignKey(
                        name: "FK__Ocjena__Korisnik__3F466844",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK__Ocjena__UslugaId__403A8C7D",
                        column: x => x.UslugaId,
                        principalTable: "Usluga",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Zaposlenik",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: true),
                    DatumZaposlenja = table.Column<DateTime>(type: "datetime", nullable: false),
                    Struka = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Status = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Napomena = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    Biografija = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    SlikaId = table.Column<int>(type: "int", nullable: true),
                    KategorijaId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Zaposlenik", x => x.Id);
                    table.ForeignKey(
                        name: "FK__Zaposleni__Kateg__2E1BDC42",
                        column: x => x.KategorijaId,
                        principalTable: "Kategorija",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK__Zaposleni__Koris__2D27B809",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "NovostInterakcija",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NovostId = table.Column<int>(type: "int", nullable: true),
                    KorisnikId = table.Column<int>(type: "int", nullable: true),
                    IsLiked = table.Column<bool>(type: "bit", nullable: false),
                    Datum = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NovostInterakcija", x => x.Id);
                    table.ForeignKey(
                        name: "FK__NovostInt__Koris__5165187F",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK__NovostInt__Novos__5070F446",
                        column: x => x.NovostId,
                        principalTable: "Novost",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "NovostKomentar",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime", nullable: false),
                    NovostId = table.Column<int>(type: "int", nullable: true),
                    KorisnikId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NovostKomentar", x => x.Id);
                    table.ForeignKey(
                        name: "FK__NovostKom__Koris__5535A963",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK__NovostKom__Novos__5441852A",
                        column: x => x.NovostId,
                        principalTable: "Novost",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Rezervacija",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: true),
                    UslugaId = table.Column<int>(type: "int", nullable: true),
                    Datum = table.Column<DateTime>(type: "datetime", nullable: false),
                    TerminId = table.Column<int>(type: "int", nullable: true),
                    Status = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Napomena = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    ZaposlenikId = table.Column<int>(type: "int", nullable: true),
                    IsPlaceno = table.Column<bool>(type: "bit", nullable: true),
                    StatusRezervacijeId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Rezervacija", x => x.Id);
                    table.ForeignKey(
                        name: "FK__Rezervaci__Koris__4316F928",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK__Rezervaci__Statu__45F365D3",
                        column: x => x.StatusRezervacijeId,
                        principalTable: "StatusRezervacije",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK__Rezervaci__Termi__44FF419A",
                        column: x => x.TerminId,
                        principalTable: "Termin",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK__Rezervaci__Uslug__440B1D61",
                        column: x => x.UslugaId,
                        principalTable: "Usluga",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK__Rezervaci__Zapos__46E78A0C",
                        column: x => x.ZaposlenikId,
                        principalTable: "Zaposlenik",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "ZaposlenikRecenzija",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Komentar = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Ocjena = table.Column<int>(type: "int", nullable: false),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime", nullable: false),
                    ZaposlenikId = table.Column<int>(type: "int", nullable: true),
                    KorisnikId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ZaposlenikRecenzija", x => x.Id);
                    table.ForeignKey(
                        name: "FK__Zaposleni__Koris__59063A47",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK__Zaposleni__Zapos__5812160E",
                        column: x => x.ZaposlenikId,
                        principalTable: "Zaposlenik",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Favorit_KorisnikId",
                table: "Favorit",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Favorit_UslugaId",
                table: "Favorit",
                column: "UslugaId");

            migrationBuilder.CreateIndex(
                name: "IX_Komentar_KorisnikId",
                table: "Komentar",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Komentar_UslugaId",
                table: "Komentar",
                column: "UslugaId");

            migrationBuilder.CreateIndex(
                name: "IX_Korisnik_SlikaId",
                table: "Korisnik",
                column: "SlikaId");

            migrationBuilder.CreateIndex(
                name: "IX_KorisnikUloga_KorisnikId",
                table: "KorisnikUloga",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_KorisnikUloga_UlogaId",
                table: "KorisnikUloga",
                column: "UlogaId");

            migrationBuilder.CreateIndex(
                name: "IX_Novost_AutorId",
                table: "Novost",
                column: "AutorId");

            migrationBuilder.CreateIndex(
                name: "IX_NovostInterakcija_KorisnikId",
                table: "NovostInterakcija",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_NovostInterakcija_NovostId",
                table: "NovostInterakcija",
                column: "NovostId");

            migrationBuilder.CreateIndex(
                name: "IX_NovostKomentar_KorisnikId",
                table: "NovostKomentar",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_NovostKomentar_NovostId",
                table: "NovostKomentar",
                column: "NovostId");

            migrationBuilder.CreateIndex(
                name: "IX_Ocjena_KorisnikId",
                table: "Ocjena",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Ocjena_UslugaId",
                table: "Ocjena",
                column: "UslugaId");

            migrationBuilder.CreateIndex(
                name: "IX_Rezervacija_KorisnikId",
                table: "Rezervacija",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Rezervacija_StatusRezervacijeId",
                table: "Rezervacija",
                column: "StatusRezervacijeId");

            migrationBuilder.CreateIndex(
                name: "IX_Rezervacija_TerminId",
                table: "Rezervacija",
                column: "TerminId");

            migrationBuilder.CreateIndex(
                name: "IX_Rezervacija_UslugaId",
                table: "Rezervacija",
                column: "UslugaId");

            migrationBuilder.CreateIndex(
                name: "IX_Rezervacija_ZaposlenikId",
                table: "Rezervacija",
                column: "ZaposlenikId");

            migrationBuilder.CreateIndex(
                name: "IX_Usluga_KategorijaId",
                table: "Usluga",
                column: "KategorijaId");

            migrationBuilder.CreateIndex(
                name: "IX_Zaposlenik_KategorijaId",
                table: "Zaposlenik",
                column: "KategorijaId");

            migrationBuilder.CreateIndex(
                name: "IX_Zaposlenik_KorisnikId",
                table: "Zaposlenik",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_ZaposlenikRecenzija_KorisnikId",
                table: "ZaposlenikRecenzija",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_ZaposlenikRecenzija_ZaposlenikId",
                table: "ZaposlenikRecenzija",
                column: "ZaposlenikId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Favorit");

            migrationBuilder.DropTable(
                name: "Komentar");

            migrationBuilder.DropTable(
                name: "KorisnikUloga");

            migrationBuilder.DropTable(
                name: "NovostInterakcija");

            migrationBuilder.DropTable(
                name: "NovostKomentar");

            migrationBuilder.DropTable(
                name: "Ocjena");

            migrationBuilder.DropTable(
                name: "Rezervacija");

            migrationBuilder.DropTable(
                name: "ZaposlenikRecenzija");

            migrationBuilder.DropTable(
                name: "Uloga");

            migrationBuilder.DropTable(
                name: "Novost");

            migrationBuilder.DropTable(
                name: "StatusRezervacije");

            migrationBuilder.DropTable(
                name: "Termin");

            migrationBuilder.DropTable(
                name: "Usluga");

            migrationBuilder.DropTable(
                name: "Zaposlenik");

            migrationBuilder.DropTable(
                name: "Kategorija");

            migrationBuilder.DropTable(
                name: "Korisnik");

            migrationBuilder.DropTable(
                name: "SlikaProfila");
        }
    }
}
