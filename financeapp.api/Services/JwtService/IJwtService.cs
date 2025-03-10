using financeapp.api.Entities;

namespace financeapp.api.Services.JwtService;

public interface IJwtService
{
    string GenerateToken(User user);
}
