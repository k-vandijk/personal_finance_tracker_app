namespace financeapp.api.Entities;

public class Asset : BaseEntity
{
    public string Name { get; set; }
    public string? Description { get; set; }

    public DateTime PurchaseDate { get; set; }
    public DateTime? SaleDate { get; set; }

    public decimal PurchasePrice { get; set; }
    public decimal? SalePrice { get; set; }
    public decimal? FictionalPrice { get; set; }

    // Navigation properties
    public Guid CategoryId { get; set; }
    public virtual Category Category { get; set; }

    public Guid UserId { get; set; }
    public virtual User User { get; set; }
}
