namespace financeapp.api.DTOs;

public class AuthenticationDTO
{
    public string Email { get; set; }
    public string Password { get; set; }
}

public class AuthenticationResponseDTO
{
    public string Token { get; set; }
}
