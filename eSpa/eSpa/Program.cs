//using eSpa.Service.Database;
using eSpa;
using eSpa.Filters;
using eSpa.Service;
using eSpa.Service.Database;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers(/* x=> {
        x.Filters.Add<ErrorFilter>();
    }*/);
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
//builder.Services.AddSwaggerGen();

builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth"}
            },
            new string[]{}
    } });

});



var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<eSpaContext>(options => options.UseSqlServer(connectionString));
builder.Services.AddAutoMapper(typeof(IKategorijaService));  //prije bilo startup

//builder.Services.AddAuthentication("BasicAuthentication")
   // .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);


builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);


builder.Services.AddTransient<IKorisniciService, KorisniciService>(); //plus dodat sve ostalo
//builder.Services.AddScoped<IUslugaService, UslugaService>();
builder.Services.AddTransient<IKategorijaService, KategorijaService>();
builder.Services.AddTransient<IUslugaService, UslugaService>();
//builder.Services.AddTransient<IKategorijaService, KategorijaService>();
builder.Services.AddTransient<IKomentarService, KomentarService>();
builder.Services.AddTransient<INovostService, NovostService>();
builder.Services.AddTransient<IOcjenaService, OcjenaService>();
builder.Services.AddTransient<ITerminService, TerminService>();
builder.Services.AddTransient<IRezervacijaService,RezervacijaService>();
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();



app.MapControllers();

app.Run();
