using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace eSpa.Service.Database
{
    public partial class eSpaContext : DbContext
    {
        public eSpaContext()
        {
        }

        public eSpaContext(DbContextOptions<eSpaContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Favorit> Favorits { get; set; } = null!;
        public virtual DbSet<Kategorija> Kategorijas { get; set; } = null!;
        public virtual DbSet<Komentar> Komentars { get; set; } = null!;
        public virtual DbSet<Korisnik> Korisniks { get; set; } = null!;
        public virtual DbSet<KorisnikUloga> KorisnikUlogas { get; set; } = null!;
        public virtual DbSet<Novost> Novosts { get; set; } = null!;
        public virtual DbSet<NovostInterakcija> NovostInterakcijas { get; set; } = null!;
        public virtual DbSet<NovostKomentar> NovostKomentars { get; set; } = null!;
        public virtual DbSet<Ocjena> Ocjenas { get; set; } = null!;
        public virtual DbSet<Rezervacija> Rezervacijas { get; set; } = null!;
        public virtual DbSet<SlikaProfila> SlikaProfilas { get; set; } = null!;
        public virtual DbSet<Termin> Termins { get; set; } = null!;
        public virtual DbSet<Uloga> Ulogas { get; set; } = null!;
        public virtual DbSet<Usluga> Uslugas { get; set; } = null!;
        public virtual DbSet<Zaposlenik> Zaposleniks { get; set; } = null!;
        public virtual DbSet<ZaposlenikRecenzija> ZaposlenikRecenzijas { get; set; } = null!;
        public virtual DbSet<ZaposlenikSlike> ZaposlenikSlikes { get; set; } = null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
                optionsBuilder.UseSqlServer("Data Source=localhost; Initial Catalog=eSpa; Integrated Security=True;");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Favorit>(entity =>
            {
                entity.ToTable("Favorit");

                entity.Property(e => e.Datum)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.IsFavorit)
                    .IsRequired()
                    .HasDefaultValueSql("((1))");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Favorits)
                    .HasForeignKey(d => d.KorisnikId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Favorit__Korisni__282DF8C2");

                entity.HasOne(d => d.Usluga)
                    .WithMany(p => p.Favorits)
                    .HasForeignKey(d => d.UslugaId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Favorit__UslugaI__29221CFB");
            });

            modelBuilder.Entity<Kategorija>(entity =>
            {
                entity.ToTable("Kategorija");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Naziv)
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("naziv");
            });

            modelBuilder.Entity<Komentar>(entity =>
            {
                entity.ToTable("Komentar");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Datum)
                    .HasColumnType("date")
                    .HasColumnName("datum");

                entity.Property(e => e.KorisnikId).HasColumnName("korisnik_id");

                entity.Property(e => e.Preporuka).HasColumnName("preporuka");

                entity.Property(e => e.Tekst).HasColumnName("tekst");

                entity.Property(e => e.UslugaId).HasColumnName("usluga_id");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Komentars)
                    .HasForeignKey(d => d.KorisnikId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Komentar__korisn__3F466844");

                entity.HasOne(d => d.Usluga)
                    .WithMany(p => p.Komentars)
                    .HasForeignKey(d => d.UslugaId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Komentar__usluga__403A8C7D");
            });

            modelBuilder.Entity<Korisnik>(entity =>
            {
                entity.ToTable("Korisnik");

                entity.HasIndex(e => e.Email, "UQ__Korisnik__AB6E6164B3720F4D")
                    .IsUnique();

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.DatumRegistracije)
                    .HasColumnType("date")
                    .HasColumnName("datum_registracije");

                entity.Property(e => e.Email)
                    .HasMaxLength(100)
                    .IsUnicode(false)
                    .HasColumnName("email");

                entity.Property(e => e.Ime)
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("ime");

                entity.Property(e => e.IsAdmin).HasColumnName("isAdmin");

                entity.Property(e => e.IsBlokiran).HasColumnName("isBlokiran");

                entity.Property(e => e.IsZaposlenik).HasColumnName("isZaposlenik");

                entity.Property(e => e.KorisnickoIme)
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("korisnickoIme");

                entity.Property(e => e.LozinkaHash).HasColumnName("lozinkaHash");

                entity.Property(e => e.LozinkaSalt).HasColumnName("lozinkaSalt");

                entity.Property(e => e.Prezime)
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("prezime");

                entity.Property(e => e.Status)
                    .HasMaxLength(50)
                    .HasColumnName("status");

                entity.Property(e => e.Telefon)
                    .HasMaxLength(20)
                    .IsUnicode(false)
                    .HasColumnName("telefon");

                entity.HasOne(d => d.Slika)
                    .WithMany(p => p.Korisniks)
                    .HasForeignKey(d => d.SlikaId)
                    .HasConstraintName("FK_Korisnik_SlikaId");
            });

            modelBuilder.Entity<KorisnikUloga>(entity =>
            {
                entity.ToTable("KorisnikUloga");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.DatumDodele)
                    .HasColumnType("date")
                    .HasColumnName("datum_dodele");

                entity.Property(e => e.KorisnikId).HasColumnName("korisnik_id");

                entity.Property(e => e.UlogaId).HasColumnName("uloga_id");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.KorisnikUlogas)
                    .HasForeignKey(d => d.KorisnikId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__KorisnikU__koris__4316F928");

                entity.HasOne(d => d.Uloga)
                    .WithMany(p => p.KorisnikUlogas)
                    .HasForeignKey(d => d.UlogaId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__KorisnikU__uloga__440B1D61");
            });

            modelBuilder.Entity<Novost>(entity =>
            {
                entity.ToTable("Novost");

                entity.Property(e => e.DatumKreiranja).HasColumnType("datetime");

                entity.Property(e => e.Naslov).HasMaxLength(255);

                entity.Property(e => e.Sadrzaj).HasColumnType("text");

                entity.Property(e => e.Status).HasMaxLength(255);

                entity.HasOne(d => d.Autor)
                    .WithMany(p => p.Novosts)
                    .HasForeignKey(d => d.AutorId)
                    .HasConstraintName("FK__Novost__AutorID__72C60C4A");
            });

            modelBuilder.Entity<NovostInterakcija>(entity =>
            {
                entity.ToTable("NovostInterakcija");

                entity.Property(e => e.Datum)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.NovostInterakcijas)
                    .HasForeignKey(d => d.KorisnikId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__NovostInt__Koris__2DE6D218");

                entity.HasOne(d => d.Novost)
                    .WithMany(p => p.NovostInterakcijas)
                    .HasForeignKey(d => d.NovostId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__NovostInt__Novos__2CF2ADDF");
            });

            modelBuilder.Entity<NovostKomentar>(entity =>
            {
                entity.ToTable("NovostKomentar");

                entity.Property(e => e.DatumKreiranja)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.NovostKomentars)
                    .HasForeignKey(d => d.KorisnikId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__NovostKom__Koris__17F790F9");

                entity.HasOne(d => d.Novost)
                    .WithMany(p => p.NovostKomentars)
                    .HasForeignKey(d => d.NovostId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__NovostKom__Novos__17036CC0");
            });

            modelBuilder.Entity<Ocjena>(entity =>
            {
                entity.ToTable("Ocjena");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Datum)
                    .HasColumnType("date")
                    .HasColumnName("datum");

                entity.Property(e => e.KorisnikId).HasColumnName("korisnik_id");

                entity.Property(e => e.Ocjena1).HasColumnName("ocjena");

                entity.Property(e => e.UslugaId).HasColumnName("usluga_id");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Ocjenas)
                    .HasForeignKey(d => d.KorisnikId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Ocjena__korisnik__3B75D760");

                entity.HasOne(d => d.Usluga)
                    .WithMany(p => p.Ocjenas)
                    .HasForeignKey(d => d.UslugaId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Ocjena__usluga_i__3C69FB99");
            });

            modelBuilder.Entity<Rezervacija>(entity =>
            {
                entity.ToTable("Rezervacija");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Datum)
                    .HasColumnType("date")
                    .HasColumnName("datum");

                entity.Property(e => e.KorisnikId).HasColumnName("korisnik_id");

                entity.Property(e => e.Status)
                    .HasMaxLength(50)
                    .HasColumnName("status");

                entity.Property(e => e.TerminId).HasColumnName("termin_id");

                entity.Property(e => e.UslugaId).HasColumnName("usluga_id");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Rezervacijas)
                    .HasForeignKey(d => d.KorisnikId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Rezervaci__koris__33D4B598");

                entity.HasOne(d => d.Termin)
                    .WithMany(p => p.Rezervacijas)
                    .HasForeignKey(d => d.TerminId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Rezervaci__termi__35BCFE0A");

                entity.HasOne(d => d.Usluga)
                    .WithMany(p => p.Rezervacijas)
                    .HasForeignKey(d => d.UslugaId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Rezervaci__uslug__34C8D9D1");

                entity.HasOne(d => d.Zaposlenik)
                    .WithMany(p => p.Rezervacijas)
                    .HasForeignKey(d => d.ZaposlenikId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Rezervacija_Zaposlenik");
            });

            modelBuilder.Entity<SlikaProfila>(entity =>
            {
                entity.ToTable("SlikaProfila");

                entity.Property(e => e.DatumPostavljanja).HasColumnType("datetime");

                entity.Property(e => e.Naziv).HasMaxLength(255);

                entity.Property(e => e.Tip)
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<Termin>(entity =>
            {
                entity.ToTable("Termin");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Kraj).HasColumnName("kraj");

                entity.Property(e => e.Pocetak).HasColumnName("pocetak");
            });

            modelBuilder.Entity<Uloga>(entity =>
            {
                entity.ToTable("Uloga");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Naziv)
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("naziv");
            });

            modelBuilder.Entity<Usluga>(entity =>
            {
                entity.ToTable("Usluga");

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Cijena)
                    .HasColumnType("decimal(10, 2)")
                    .HasColumnName("cijena");

                entity.Property(e => e.KategorijaId).HasColumnName("kategorija_id");

                entity.Property(e => e.Naziv)
                    .HasMaxLength(100)
                    .IsUnicode(false)
                    .HasColumnName("naziv");

                entity.Property(e => e.Opis)
                    .HasColumnType("text")
                    .HasColumnName("opis");

                entity.Property(e => e.Trajanje)
                    .HasMaxLength(10)
                    .IsUnicode(false)
                    .HasColumnName("trajanje");

                entity.HasOne(d => d.Kategorija)
                    .WithMany(p => p.Uslugas)
                    .HasForeignKey(d => d.KategorijaId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Usluga__kategori__2E1BDC42");
            });

            modelBuilder.Entity<Zaposlenik>(entity =>
            {
                entity.ToTable("Zaposlenik");

                entity.Property(e => e.Biografija).HasColumnType("text");

                entity.Property(e => e.DatumZaposlenja).HasColumnType("datetime");

                entity.Property(e => e.Napomena).HasColumnType("text");

                entity.Property(e => e.Status)
                    .HasMaxLength(20)
                    .HasDefaultValueSql("('Aktivan')");

                entity.Property(e => e.Struka).HasMaxLength(100);

                entity.HasOne(d => d.Kategorija)
                    .WithMany(p => p.Zaposleniks)
                    .HasForeignKey(d => d.KategorijaId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Zaposlenik_Kategorija");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Zaposleniks)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__Zaposleni__Koris__6FE99F9F");

                entity.HasOne(d => d.Slika)
                    .WithMany(p => p.Zaposleniks)
                    .HasForeignKey(d => d.SlikaId)
                    .OnDelete(DeleteBehavior.SetNull)
                    .HasConstraintName("FK_Zaposlenik_Slika");
            });

            modelBuilder.Entity<ZaposlenikRecenzija>(entity =>
            {
                entity.ToTable("ZaposlenikRecenzija");

                entity.Property(e => e.DatumKreiranja)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.ZaposlenikRecenzijas)
                    .HasForeignKey(d => d.KorisnikId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Zaposleni__Koris__1DB06A4F");

                entity.HasOne(d => d.Zaposlenik)
                    .WithMany(p => p.ZaposlenikRecenzijas)
                    .HasForeignKey(d => d.ZaposlenikId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Zaposleni__Zapos__1CBC4616");
            });

            modelBuilder.Entity<ZaposlenikSlike>(entity =>
            {
                entity.ToTable("ZaposlenikSlike");

                entity.Property(e => e.DatumPostavljanja)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Naziv)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.Tip)
                    .HasMaxLength(50)
                    .IsUnicode(false);
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
