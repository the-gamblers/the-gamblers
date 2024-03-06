using System;
using Microsoft.AspNetCore.Mvc;
using ChessMasterAPI.Services;
using ChessMasterAPI.Models;
using Microsoft.AspNetCore.Http.HttpResults;

namespace ChessMasterAPI.Controllers;

[Controller]
[Route("api/[controller]")]
public class UserController: Controller {

    private readonly MongoDBService _mongoDBService;

    public UserController(MongoDBService mongoDBService){
        _mongoDBService = mongoDBService;
    }

    [HttpGet]
    public async Task<List<User>> Get() {
        return await _mongoDBService.GetUsersAsync();
    }

    [HttpPost]
    public async Task<IActionResult> Post([FromBody] User user) {
        await _mongoDBService.CreatedAsync(user);
        return CreatedAtAction(nameof(Get),new {id = user.Id}, user);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> ChangeEmail(string id, [FromBody] string newEmail) {
        await _mongoDBService.ChangeEmailAsync(id, newEmail);
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(string id) {
        await _mongoDBService.DeleteAsync(id);
        return NoContent();
    }
}