using financeapp.api.DTOs;
using financeapp.api.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace financeapp.api.Controllers;

[Route("api/v1/[controller]")]
[ApiController]
public class AssetsController : BaseController
{
    // TODO User AutoMapper to map entities to DTOs
    // TODO Move business logic to service

    private readonly DataContext _context;
    public AssetsController(DataContext context) : base(context)
    {
        _context = context;
    }

    [HttpPost("create")]
    public async Task<ActionResult> CreateAsset(AssetDTO dto)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        User currentUser = await GetCurrentUserAsync();
        if (currentUser == null)
        {
            return Unauthorized("User not found.");
        }

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
        return Ok(AssetToDTO(asset));
    }

    [HttpGet("getall")]
    public async Task<ActionResult<IEnumerable<Asset>>> GetAssets()
    {
        User currentUser = await GetCurrentUserAsync();
        if (currentUser == null)
        {
            return Unauthorized("User not found.");
        }

        IEnumerable<Asset> assets = await _context.Assets.Where(a => a.Active && a.UserId == currentUser.Id).ToListAsync();
        return Ok(assets.Select(AssetToDTO));
    }

    [HttpGet("get/{id:guid}")]
    public async Task<ActionResult<Asset>> GetAsset(Guid id)
    {
        User currentUser = await GetCurrentUserAsync();
        if (currentUser == null)
        {
            return Unauthorized("User not found.");
        }

        Asset asset = await _context.Assets.FirstOrDefaultAsync(a => a.Active && a.UserId == currentUser.Id && a.Id == id);
        if (asset == null)
        {
            return NotFound("Asset not found.");
        }

        return Ok(AssetToDTO(asset));
    }

    [HttpPut("update/{id:guid}")]
    public async Task<ActionResult<Asset>> UpdateAsset(Guid id, AssetDTO dto)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        User currentUser = await GetCurrentUserAsync();
        if (currentUser == null)
        {
            return Unauthorized("User not found.");
        }

        Asset asset = await _context.Assets.FirstOrDefaultAsync(a => a.Active && a.UserId == currentUser.Id && a.Id == id);
        if (asset == null)
        {
            return NotFound("Asset not found.");
        }

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

        return Ok(AssetToDTO(asset));
    }

    [HttpDelete("delete/{id:guid}")]
    public async Task<ActionResult> DeleteAsset(Guid id)
    {
        User currentUser = await GetCurrentUserAsync();
        if (currentUser == null)
        {
            return Unauthorized("User not found.");
        }

        Asset asset = await _context.Assets.FirstOrDefaultAsync(a => a.Active && a.UserId == currentUser.Id && a.Id == id);
        if (asset == null)
        {
            return NotFound("Asset not found.");
        }

        asset.Active = false;
        asset.UpdatedAt = DateTime.UtcNow;
        _context.Assets.Update(asset);
        await _context.SaveChangesAsync();

        return Ok("Asset deleted successfully.");
    }

    private AssetDTO AssetToDTO(Asset asset)
    {
        AssetDTO dto = new()
        {
            Id = asset.Id,
            CategoryId = asset.CategoryId,
            Name = asset.Name,
            PurchaseDate = asset.PurchaseDate,
            PurchasePrice = asset.PurchasePrice,
            Description = asset.Description,
            SaleDate = asset.SaleDate,
            SalePrice = asset.SalePrice,
            FictionalPrice = asset.FictionalPrice
        };

        return dto;
    }
}
