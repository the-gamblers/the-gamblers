using ChessMasterAPI.Models;
using Microsoft.Extensions.Options;
using MongoDB.Driver;
using MongoDB.Bson;
using Microsoft.AspNetCore.Mvc;

namespace ChessMasterAPI.Services;

public class MongoDBService
{

    private readonly IMongoCollection<User> _userCollection;
    private readonly IMongoCollection<Game> _gameCollection;

    public MongoDBService(IOptions<MongoDBSettings> mongoDBSettings)
    {
        MongoClient client = new MongoClient(mongoDBSettings.Value.ConnectionURI);
        IMongoDatabase database = client.GetDatabase(mongoDBSettings.Value.DatabaseName);
        _userCollection = database.GetCollection<User>(mongoDBSettings.Value.CollectionName);
        _gameCollection = database.GetCollection<Game>(mongoDBSettings.Value.CollectionName);
    }

    // USER DATA
    public async Task CreatedAsync(User user)
    {
        await _userCollection.InsertOneAsync(user);
        return;
    }
    public async Task<User> GetByID(string id)
    {
        User byId = await _userCollection.Find(m => m.Id == id).FirstOrDefaultAsync();
        return byId;
    }
    public async Task<List<User>> GetUsersAsync() =>
        await _userCollection.Find(_ => true).ToListAsync();

    public async Task ChangeEmailAsync(string id, string email)
    {
        FilterDefinition<User> filter = Builders<User>.Filter.Eq("Id", id);
        UpdateDefinition<User> update = Builders<User>.Update.Set<string>("email", email);
        await _userCollection.UpdateOneAsync(filter, update);
        return;
    }

    public async Task DeleteAsync(string id)
    {
        FilterDefinition<User> filter = Builders<User>.Filter.Eq("Id", id);
        await _userCollection.DeleteOneAsync(filter);
        return;
    }

    // // GAME DATA
    // public async Task CreatedAsync(Game game)
    // {
    //     await _gameCollection.InsertOneAsync(game);
    //     return;
    // }
    // public async Task<Game> GetByID(string id)
    // {
    //     Game byId = await _gameCollection.Find(m => m.Id == id).FirstOrDefaultAsync();
    //     return byId;
    // }
    // public async Task<List<Game>> GetGamesAsync() =>
    //     await _gameCollection.Find(_ => true).ToListAsync();

    // // public async Task ChangeEmailAsync(string id, string email)
    // // {
    // //     FilterDefinition<Game> filter = Builders<Game>.Filter.Eq("Id", id);
    // //     UpdateDefinition<Game> update = Builders<Game>.Update.Set<string>("email", email);
    // //     await _gameCollection.UpdateOneAsync(filter, update);
    // //     return;
    // // }

    // public async Task DeleteAsync(string id)
    // {
    //     FilterDefinition<Game> filter = Builders<Game>.Filter.Eq("Id", id);
    //     await _gameCollection.DeleteOneAsync(filter);
    //     return;
    // }
}