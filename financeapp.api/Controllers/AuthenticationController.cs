using financeapp.api.DTOs;
using financeapp.api.Entities;
using financeapp.api.Services.HashingService;
using financeapp.api.Services.JwtService;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace financeapp.api.Controllers;

[ApiController]
[Route("api/v1/auth")]
public class AuthenticationController : BaseController
{
    private readonly DataContext _context;
    private readonly IHashingService _hashingService;
    private readonly IJwtService _jwtService;

    public AuthenticationController(DataContext context, IHashingService hashingService, IJwtService jwtService)
        : base(context)
    {
        _context = context;
        _hashingService = hashingService;
        _jwtService = jwtService;
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register(AuthenticationDTO dto)
    {
        if (string.IsNullOrWhiteSpace(dto.Email) || string.IsNullOrWhiteSpace(dto.Password))
            return BadRequest("Email and password are required.");

        if (await _context.Users.AnyAsync(u => u.Email.ToUpper() == dto.Email.ToUpper()))
            return BadRequest("User already exists.");

        string passwordSalt = _hashingService.GenerateSalt();
        string passwordHash = _hashingService.Hash(dto.Password, passwordSalt);

        var user = new User
        {
            Email = dto.Email.ToUpper(),
            PasswordHash = passwordHash,
            PasswordSalt = passwordSalt
        };

        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        return await SignInUserAsync(user);
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login(AuthenticationDTO dto)
    {
        if (string.IsNullOrWhiteSpace(dto.Email) || string.IsNullOrWhiteSpace(dto.Password))
            return BadRequest("Email and password are required.");

        var user = await _context.Users.FirstOrDefaultAsync(u => u.Email.ToUpper() == dto.Email.ToUpper());
        if (user == null || !_hashingService.Verify(dto.Password, user.PasswordHash, user.PasswordSalt))
            return Unauthorized("Invalid credentials.");

        return await SignInUserAsync(user);
    }

    private async Task<IActionResult> SignInUserAsync(User user)
    {
        var token = _jwtService.GenerateToken(user);
        return await Task.FromResult(Ok(new { token }));
    }
}
