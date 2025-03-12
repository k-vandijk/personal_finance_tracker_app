using financeapp.api.DTOs;
using financeapp.api.Services.CategoriesService;
using Microsoft.AspNetCore.Mvc;

namespace financeapp.api.Controllers;

[Route("api/v1/categories")]
[ApiController]
public class CategoriesController : BaseController
{
    private readonly ICategoriesService _categoriesService;

    public CategoriesController(DataContext context, ICategoriesService categoriesService) : base(context)
    {
        _categoriesService = categoriesService;
    }

    [HttpGet("getall")]
    [ProducesResponseType<IEnumerable<CategoryDTO>>(200)]
    [ProducesResponseType(401)]
    public async Task<ActionResult<IEnumerable<CategoryDTO>>> GetCategories()
    {
        var currentUser = await GetCurrentUserAsync();
        if (currentUser == null)
        {
            return Unauthorized("User not found.");
        }

        var categories = await _categoriesService.GetCategoriesAsync();
        return Ok(categories);
    }
}


