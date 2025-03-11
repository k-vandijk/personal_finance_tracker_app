using AutoMapper;
using financeapp.api.DTOs;
using financeapp.api.Entities;
using Microsoft.EntityFrameworkCore;

namespace financeapp.api.Services.AssetsService;

public class AssetsService : IAssetsService
{
    private readonly DataContext _context;
    private readonly IMapper _mapper;

    public AssetsService(DataContext context, IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    public async Task<AssetDTO> CreateAssetAsync(AssetDTO dto, User currentUser)
    {
        Asset asset = new Asset
        {
            Name = dto.Name,
            Description = dto.Description,
            PurchaseDate = dto.PurchaseDate.ToUniversalTime(),
            PurchasePrice = dto.PurchasePrice,
            FictionalPrice = dto.FictionalPrice,
            CategoryId = dto.CategoryId,
            UserId = currentUser.Id,
        };

        _context.Assets.Add(asset);
        await _context.SaveChangesAsync();
        return _mapper.Map<AssetDTO>(asset);
    }

    public async Task<IEnumerable<AssetDTO>> GetAssetsAsync(User currentUser)
    {
        var assets = await _context.Assets
            .Where(a => a.Active && a.UserId == currentUser.Id)
            .ToListAsync();

        return assets.Select(a => _mapper.Map<AssetDTO>(a));
    }

    public async Task<AssetDTO> GetAssetAsync(Guid id, User currentUser)
    {
        var asset = await _context.Assets
            .FirstOrDefaultAsync(a => a.Active && a.UserId == currentUser.Id && a.Id == id);

        return asset == null ? null : _mapper.Map<AssetDTO>(asset);
    }

    public async Task<AssetDTO> UpdateAssetAsync(Guid id, AssetDTO dto, User currentUser)
    {
        var asset = await _context.Assets
            .FirstOrDefaultAsync(a => a.Active && a.UserId == currentUser.Id && a.Id == id);

        if (asset == null) return null;

        asset.Name = dto.Name;
        asset.Description = dto.Description;
        asset.PurchaseDate = dto.PurchaseDate.ToUniversalTime();
        asset.PurchasePrice = dto.PurchasePrice;
        asset.SaleDate = dto.SaleDate?.ToUniversalTime();
        asset.SalePrice = dto.SalePrice;
        asset.FictionalPrice = dto.FictionalPrice;
        asset.CategoryId = dto.CategoryId;
        asset.UpdatedAt = DateTime.UtcNow;

        _context.Assets.Update(asset);
        await _context.SaveChangesAsync();

        return _mapper.Map<AssetDTO>(asset);
    }

    public async Task<bool> DeleteAssetAsync(Guid id, User currentUser)
    {
        var asset = await _context.Assets
            .FirstOrDefaultAsync(a => a.Active && a.UserId == currentUser.Id && a.Id == id);

        if (asset == null) return false;

        asset.Active = false;
        asset.UpdatedAt = DateTime.UtcNow;
        _context.Assets.Update(asset);
        await _context.SaveChangesAsync();

        return true;
    }
}
