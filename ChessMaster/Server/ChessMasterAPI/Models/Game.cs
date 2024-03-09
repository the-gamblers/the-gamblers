using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System.Text.Json.Serialization;

namespace ChessMasterAPI.Models;

[BsonIgnoreExtraElements]
public class Game
{
    [BsonId]
    [BsonRepresentation(MongoDB.Bson.BsonType.ObjectId)]
    public string? Id { get; set; }
    public string? title { get; set; } = null!;
    public string? subtitle { get; set; } = null!;
    public string? notes { get; set; } = null!;
    public string? link { get; set; } = null!;
}