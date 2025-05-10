using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace eSpa.Service.Database
{
    public partial class IB200069Context : DbContext
    {
        public IB200069Context()
        {
        }

        public IB200069Context(DbContextOptions<IB200069Context> options)
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
        public virtual DbSet<StatusRezervacije> StatusRezervacijes { get; set; } = null!;
        public virtual DbSet<Termin> Termins { get; set; } = null!;
        public virtual DbSet<Uloga> Ulogas { get; set; } = null!;
        public virtual DbSet<Usluga> Uslugas { get; set; } = null!;
        public virtual DbSet<Zaposlenik> Zaposleniks { get; set; } = null!;
        public virtual DbSet<ZaposlenikRecenzija> ZaposlenikRecenzijas { get; set; } = null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
                optionsBuilder.UseSqlServer("Server=localhost,1433;Database=IB200069;User=sa;Password=NovaSifra123!;TrustServerCertificate=True;");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Favorit>(entity =>
            {
                entity.ToTable("Favorit");

                entity.Property(e => e.Datum).HasColumnType("datetime");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Favorits)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__Favorit__Korisni__37A5467C");

                entity.HasOne(d => d.Usluga)
                    .WithMany(p => p.Favorits)
                    .HasForeignKey(d => d.UslugaId)
                    .HasConstraintName("FK__Favorit__UslugaI__38996AB5");
            });

            modelBuilder.Entity<Kategorija>(entity =>
            {
                entity.ToTable("Kategorija");

                entity.Property(e => e.Naziv).HasMaxLength(255);
            });

            modelBuilder.Entity<Komentar>(entity =>
            {
                entity.ToTable("Komentar");

                entity.Property(e => e.Datum).HasColumnType("datetime");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Komentars)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__Komentar__Korisn__3B75D760");

                entity.HasOne(d => d.Usluga)
                    .WithMany(p => p.Komentars)
                    .HasForeignKey(d => d.UslugaId)
                    .HasConstraintName("FK__Komentar__Usluga__3C69FB99");
            });

            modelBuilder.Entity<Korisnik>(entity =>
            {
                entity.ToTable("Korisnik");

                entity.Property(e => e.DatumRegistracije).HasColumnType("datetime");

                entity.Property(e => e.Email).HasMaxLength(255);

                entity.Property(e => e.Ime).HasMaxLength(255);

                entity.Property(e => e.KorisnickoIme).HasMaxLength(255);

                entity.Property(e => e.Prezime).HasMaxLength(255);

                entity.Property(e => e.Status).HasMaxLength(50);

                entity.Property(e => e.Telefon).HasMaxLength(50);

                entity.HasOne(d => d.Slika)
                    .WithMany(p => p.Korisniks)
                    .HasForeignKey(d => d.SlikaId)
                    .HasConstraintName("FK__Korisnik__SlikaI__2A4B4B5E");
            });

            modelBuilder.Entity<KorisnikUloga>(entity =>
            {
                entity.ToTable("KorisnikUloga");

                entity.Property(e => e.DatumDodele).HasColumnType("datetime");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.KorisnikUlogas)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__KorisnikU__Koris__49C3F6B7");

                entity.HasOne(d => d.Uloga)
                    .WithMany(p => p.KorisnikUlogas)
                    .HasForeignKey(d => d.UlogaId)
                    .HasConstraintName("FK__KorisnikU__Uloga__4AB81AF0");
            });

            modelBuilder.Entity<Novost>(entity =>
            {
                entity.ToTable("Novost");

                entity.Property(e => e.DatumKreiranja).HasColumnType("datetime");

                entity.Property(e => e.Naslov).HasMaxLength(255);

                entity.Property(e => e.Status).HasMaxLength(50);

                entity.HasOne(d => d.Autor)
                    .WithMany(p => p.Novosts)
                    .HasForeignKey(d => d.AutorId)
                    .HasConstraintName("FK__Novost__AutorId__4D94879B");
            });

            modelBuilder.Entity<NovostInterakcija>(entity =>
            {
                entity.ToTable("NovostInterakcija");

                entity.Property(e => e.Datum).HasColumnType("datetime");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.NovostInterakcijas)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__NovostInt__Koris__5165187F");

                entity.HasOne(d => d.Novost)
                    .WithMany(p => p.NovostInterakcijas)
                    .HasForeignKey(d => d.NovostId)
                    .HasConstraintName("FK__NovostInt__Novos__5070F446");
            });

            modelBuilder.Entity<NovostKomentar>(entity =>
            {
                entity.ToTable("NovostKomentar");

                entity.Property(e => e.DatumKreiranja).HasColumnType("datetime");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.NovostKomentars)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__NovostKom__Koris__5535A963");

                entity.HasOne(d => d.Novost)
                    .WithMany(p => p.NovostKomentars)
                    .HasForeignKey(d => d.NovostId)
                    .HasConstraintName("FK__NovostKom__Novos__5441852A");
            });

            modelBuilder.Entity<Ocjena>(entity =>
            {
                entity.ToTable("Ocjena");

                entity.Property(e => e.Datum).HasColumnType("datetime");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Ocjenas)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__Ocjena__Korisnik__3F466844");

                entity.HasOne(d => d.Usluga)
                    .WithMany(p => p.Ocjenas)
                    .HasForeignKey(d => d.UslugaId)
                    .HasConstraintName("FK__Ocjena__UslugaId__403A8C7D");
            });

            modelBuilder.Entity<Rezervacija>(entity =>
            {
                entity.ToTable("Rezervacija");

                entity.Property(e => e.Datum).HasColumnType("datetime");

                entity.Property(e => e.Napomena).HasMaxLength(255);

                entity.Property(e => e.Status).HasMaxLength(50);

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Rezervacijas)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__Rezervaci__Koris__4316F928");

                entity.HasOne(d => d.StatusRezervacije)
                    .WithMany(p => p.Rezervacijas)
                    .HasForeignKey(d => d.StatusRezervacijeId)
                    .HasConstraintName("FK__Rezervaci__Statu__45F365D3");

                entity.HasOne(d => d.Termin)
                    .WithMany(p => p.Rezervacijas)
                    .HasForeignKey(d => d.TerminId)
                    .HasConstraintName("FK__Rezervaci__Termi__44FF419A");

                entity.HasOne(d => d.Usluga)
                    .WithMany(p => p.Rezervacijas)
                    .HasForeignKey(d => d.UslugaId)
                    .HasConstraintName("FK__Rezervaci__Uslug__440B1D61");

                entity.HasOne(d => d.Zaposlenik)
                    .WithMany(p => p.Rezervacijas)
                    .HasForeignKey(d => d.ZaposlenikId)
                    .HasConstraintName("FK__Rezervaci__Zapos__46E78A0C");
            });

            modelBuilder.Entity<SlikaProfila>(entity =>
            {
                entity.ToTable("SlikaProfila");

                entity.Property(e => e.DatumPostavljanja).HasColumnType("datetime");

                entity.Property(e => e.Naziv).HasMaxLength(255);

                entity.Property(e => e.Tip).HasMaxLength(50);
            });

            modelBuilder.Entity<StatusRezervacije>(entity =>
            {
                entity.ToTable("StatusRezervacije");

                entity.Property(e => e.Naziv).HasMaxLength(100);

                entity.Property(e => e.Opis).HasMaxLength(255);
            });

            modelBuilder.Entity<Termin>(entity =>
            {
                entity.ToTable("Termin");
            });

            modelBuilder.Entity<Uloga>(entity =>
            {
                entity.ToTable("Uloga");

                entity.Property(e => e.Naziv).HasMaxLength(255);
            });

            modelBuilder.Entity<Usluga>(entity =>
            {
                entity.ToTable("Usluga");

                entity.Property(e => e.Cijena).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.Naziv).HasMaxLength(255);

                entity.Property(e => e.Trajanje).HasMaxLength(50);

                entity.HasOne(d => d.Kategorija)
                    .WithMany(p => p.Uslugas)
                    .HasForeignKey(d => d.KategorijaId)
                    .HasConstraintName("FK__Usluga__Kategori__34C8D9D1");
            });

            modelBuilder.Entity<Zaposlenik>(entity =>
            {
                entity.ToTable("Zaposlenik");

                entity.Property(e => e.DatumZaposlenja).HasColumnType("datetime");

                entity.Property(e => e.Napomena).HasMaxLength(255);

                entity.Property(e => e.Status).HasMaxLength(50);

                entity.Property(e => e.Struka).HasMaxLength(255);

                entity.HasOne(d => d.Kategorija)
                    .WithMany(p => p.Zaposleniks)
                    .HasForeignKey(d => d.KategorijaId)
                    .HasConstraintName("FK__Zaposleni__Kateg__2E1BDC42");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.Zaposleniks)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__Zaposleni__Koris__2D27B809");
            });

            modelBuilder.Entity<ZaposlenikRecenzija>(entity =>
            {
                entity.ToTable("ZaposlenikRecenzija");

                entity.Property(e => e.DatumKreiranja).HasColumnType("datetime");

                entity.HasOne(d => d.Korisnik)
                    .WithMany(p => p.ZaposlenikRecenzijas)
                    .HasForeignKey(d => d.KorisnikId)
                    .HasConstraintName("FK__Zaposleni__Koris__59063A47");

                entity.HasOne(d => d.Zaposlenik)
                    .WithMany(p => p.ZaposlenikRecenzijas)
                    .HasForeignKey(d => d.ZaposlenikId)
                    .HasConstraintName("FK__Zaposleni__Zapos__5812160E");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
