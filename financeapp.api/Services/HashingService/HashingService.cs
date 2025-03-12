namespace financeapp.api.Services.HashingService;

public class HashingService : IHashingService
{
    private readonly IConfiguration _config;
    public HashingService(IConfiguration config)
    {
        _config = config;
    }

    public string GenerateSalt()
    {
        var salt = BCrypt.Net.BCrypt.GenerateSalt(16);
        return salt;
    }

    public string Hash(string value, string salt)
    {
        var pepper = _config["Pepper"];
        var treatedValue = value + salt + pepper;
        var hashedValue = BCrypt.Net.BCrypt.HashPassword(treatedValue);
        return hashedValue;
    }

    public bool Verify(string enteredValue, string storedHash, string storedSalt)
    {
        var pepper = _config["Pepper"];
        var treatedValue = enteredValue + storedSalt + pepper;
        return BCrypt.Net.BCrypt.Verify(treatedValue, storedHash);
    }
}
