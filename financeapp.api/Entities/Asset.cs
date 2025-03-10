namespace financeapp.api.Entities;

public class Asset : BaseEntity
{
    public string Name { get; set; }
    public string Description { get; set; }

    public DateTime PurchaseDate { get; set; }
    public decimal PurchasePrice { get; set; }
    public DateTime? SaleDate { get; set; }
    public decimal? SalePrice { get; set; }
}
