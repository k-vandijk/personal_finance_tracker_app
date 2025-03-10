namespace financeapp.api.Entities;

public class Account : BaseEntity
{
    public string Name { get; set; }
    public string Description { get; set; }
    public decimal Balance { get; set; }
}
