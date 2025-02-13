var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
//if (app.Environment.IsDevelopment())
//{
    app.UseSwagger();
    app.UseSwaggerUI();
//}

var v1Api = app.MapGroup("/api/v1");
v1Api.MapGet("/getutcnow", () => DateTime.UtcNow.ToString());

var v2Api = app.MapGroup("/api/v2");
v2Api.MapGet("/getnow", () => DateTime.Now.ToString());

v2Api.MapGet("/test", () =>  "Updated 2025-02-13 22:20");

app.Run();


