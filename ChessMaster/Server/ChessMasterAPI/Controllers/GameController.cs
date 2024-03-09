using System;
using Microsoft.AspNetCore.Mvc;
using ChessMasterAPI.Services;
using ChessMasterAPI.Models;
using Microsoft.AspNetCore.Http.HttpResults;

namespace ChessMasterAPI.Controllers;

[Controller]
[Route("api/[controller]")]
public class GameController : Controller
{

    private readonly MongoDBService _mongoDBService;
    public GameController(MongoDBService mongoDBService)
    {
        _mongoDBService = mongoDBService;
    }

    [HttpGet]
    public async Task<List<Game>> Get()
    {
        return await _mongoDBService.GetGamesAsync();
    }

    [HttpPost]
    public async Task<IActionResult> Post([FromBody] Game Game)
    {
        await _mongoDBService.CreatedAsync(Game);
        return CreatedAtAction(nameof(Get), new { id = game.Id }, game);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> ChangeTitle(string id, [FromBody] string newTitle)
    {
        await _mongoDBService.ChangeEmailAsync(id, newTitle);
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(string id)
    {
        await _mongoDBService.DeleteAsync(id);
        return NoContent();
    }
}