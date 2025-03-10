namespace financeapp.api.Entities;

public class User : BaseEntity
{
    public string Email { get; set; }
    public string PasswordHash { get; set; }
    public string PasswordSalt { get; set; }

    public string? Firstname { get; set; }
    public string? Lastname { get; set; }
    public DateTime Birthdate { get; set; }
}
