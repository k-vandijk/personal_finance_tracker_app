using financeapp.api.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace financeapp.api.Controllers;

public class BaseController : Controller
{
    private readonly DataContext _context;

    public BaseController(DataContext context)
    {
        _context = context;
    }

    public async Task<User> GetCurrentUserAsync()
    {
        var emailClaim = User?.FindFirst(ClaimTypes.Email)?.Value;
        if (string.IsNullOrEmpty(emailClaim))
        {
            return null;
        }

        return await _context.Users.FirstOrDefaultAsync(u => u.Active && u.Email.ToUpper() == emailClaim.ToUpper());
    }
}
