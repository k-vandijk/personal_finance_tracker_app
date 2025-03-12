namespace financeapp.api.DTOs;

public class AssetDTO
{
    public Guid Id { get; set; }
    public Guid CategoryId { get; set; }

    public string Name { get; set; }
    public DateTime PurchaseDate { get; set; }
    public decimal PurchasePrice { get; set; }

    public string? Description { get; set; }
    public DateTime? SaleDate { get; set; }
    public decimal? SalePrice { get; set; }
    public decimal? FictionalPrice { get; set; }
}
