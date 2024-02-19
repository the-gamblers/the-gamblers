using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System.Text.Json.Serialization;

namespace PokerSenseiAPI.Models;

[BsonIgnoreExtraElements]
public class User {


    [BsonId]
    [BsonRepresentation(MongoDB.Bson.BsonType.ObjectId)]
    public string? Id {get; set;}

    public string? name {get; set;} = null!;
    
    public string? email {get; set;} = null!;
    public string? password {get; set;} = null!;
}