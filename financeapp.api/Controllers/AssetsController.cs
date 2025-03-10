using financeapp.api.Entities;
using Microsoft.AspNetCore.Mvc;

namespace financeapp.api.Controllers;

[Route("api/v1/[controller]")]
[ApiController]
public class AssetsController : BaseController
{
    private readonly DataContext _context;
    public AssetsController(DataContext context) : base(context)
    {
        _context = context;
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<ActionResult<Asset>> CreateAsset(Asset asset)
    {
        throw new NotImplementedException();
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Asset>>> GetAssets()
    {
        throw new NotImplementedException();
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Asset>> GetAsset(int id)
    {
        throw new NotImplementedException();
    }

    [HttpPut("{id}")]
    [ValidateAntiForgeryToken]
    public async Task<ActionResult<Asset>> UpdateAsset(int id, Asset asset)
    {
        throw new NotImplementedException();
    }

    [HttpDelete("{id}")]
    public async Task<ActionResult> DeleteAsset(int id)
    {
        throw new NotImplementedException();
    }
}
