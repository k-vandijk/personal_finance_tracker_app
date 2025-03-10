using Microsoft.AspNetCore.Mvc;

namespace financeapp.api.Controllers;

[ApiController]
[Route("api/v1/auth")]
public class AuthenticationController : BaseController
{
    private readonly DataContext _context;
    public AuthenticationController(DataContext context) : base(context)
    {
    }

    [HttpPost("register")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Register()
    {
        throw new NotImplementedException();
    }

    [HttpPost("login")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Login()
    {
        throw new NotImplementedException();
    }
}
