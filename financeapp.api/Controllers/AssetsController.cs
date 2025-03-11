using financeapp.api.DTOs;
using financeapp.api.Services.AssetsService;
using Microsoft.AspNetCore.Mvc;

namespace financeapp.api.Controllers;

[Route("api/v1/[controller]")]
[ApiController]
public class AssetsController : BaseController
{
    private readonly IAssetsService _assetsService;

    public AssetsController(DataContext context, IAssetsService assetsService) : base(context)
    {
        _assetsService = assetsService;
    }

    [HttpPost("create")]
    [ProducesResponseType<AssetDTO>(200)]
    [ProducesResponseType(400)]
    [ProducesResponseType(401)]
    [ProducesResponseType(500)]
    public async Task<ActionResult> CreateAsset(AssetDTO dto)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var currentUser = await GetCurrentUserAsync();
        if (currentUser == null)
        {
            return Unauthorized("User not found.");
        }

        var result = await _assetsService.CreateAssetAsync(dto, currentUser);
        if (result == null)
        {
            return StatusCode(500, "A problem occurred while handling your request.");
        }

        return Ok(result);
    }

    [HttpGet("getall")]
    [ProducesResponseType<IEnumerable<AssetDTO>>(200)]
    [ProducesResponseType(401)]
    public async Task<ActionResult<IEnumerable<AssetDTO>>> GetAssets()
    {
        var currentUser = await GetCurrentUserAsync();
        if (currentUser == null)
        {
            return Unauthorized("User not found.");
        }

        var assets = await _assetsService.GetAssetsAsync(currentUser);
        return Ok(assets);
    }

    [HttpGet("get/{id:guid}")]
    [ProducesResponseType<AssetDTO>(200)]
    [ProducesResponseType(401)]
    [ProducesResponseType(404)]
    public async Task<ActionResult<AssetDTO>> GetAsset(Guid id)
    {
        var currentUser = await GetCurrentUserAsync();
        if (currentUser == null)
        {
            return Unauthorized("User not found.");
        }

        var asset = await _assetsService.GetAssetAsync(id, currentUser);
        if (asset == null)
        {
            return NotFound("Asset not found.");
        }

        return Ok(asset);
    }

    [HttpPut("update/{id:guid}")]
    [ProducesResponseType<AssetDTO>(200)]
    [ProducesResponseType(400)]
    [ProducesResponseType(401)]
    [ProducesResponseType(404)]
    public async Task<ActionResult<AssetDTO>> UpdateAsset(Guid id, AssetDTO dto)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var currentUser = await GetCurrentUserAsync();
        if (currentUser == null)
        {
            return Unauthorized("User not found.");
        }

        var result = await _assetsService.UpdateAssetAsync(id, dto, currentUser);
        if (result == null)
        {
            return NotFound("Asset not found.");
        }

        return Ok(result);
    }

    [HttpDelete("delete/{id:guid}")]
    [ProducesResponseType(200)]
    [ProducesResponseType(401)]
    [ProducesResponseType(404)]
    public async Task<ActionResult> DeleteAsset(Guid id)
    {
        var currentUser = await GetCurrentUserAsync();
        if (currentUser == null)
        {
            return Unauthorized("User not found.");
        }

        var success = await _assetsService.DeleteAssetAsync(id, currentUser);
        if (!success)
        {
            return NotFound("Asset not found.");
        }

        return Ok("Asset deleted.");
    }
}


