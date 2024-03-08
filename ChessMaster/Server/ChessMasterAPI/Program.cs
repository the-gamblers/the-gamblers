using ChessMasterAPI.Models;
using ChessMasterAPI.Services;



var builder = WebApplication.CreateBuilder(args);


builder.Services.Configure<MongoDBSettings>(builder.Configuration.GetSection("MongoDB"));
builder.Services.AddSingleton<MongoDBService>();
// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.MapGet("/api/users", async(MongoDBService service) => await service.GetUsersAsync());

app.MapGet("/api/users/{id}", async(MongoDBService service, string id) => 
{
    var user = await service.GetByID(id);
    return user is null ? Results.NotFound() : Results.Ok(user);
});

app.MapPost("/api/users",async(MongoDBService service, User user) => {
    await service.CreatedAsync(user);
    return;
});

app.MapPut("/api/users/{id}", async(MongoDBService service, string id, string email) => {
    await service.ChangeEmailAsync(id, email);
    return;
});

app.MapDelete("/api/users/{id}", async(MongoDBService service, string id) => 
{
    await service.DeleteAsync(id);
    return;
});


app.Run();

