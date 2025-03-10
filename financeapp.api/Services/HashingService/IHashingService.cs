namespace financeapp.api.Services.HashingService;

public interface IHashingService
{
    string GenerateSalt();
    string Hash(string value, string salt);
    bool Verify(string enteredValue, string storedHash, string storedSalt);
}
