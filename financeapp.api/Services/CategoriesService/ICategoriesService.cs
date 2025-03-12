using financeapp.api.DTOs;

namespace financeapp.api.Services.CategoriesService;

public interface ICategoriesService
{
    Task<IEnumerable<CategoryDTO>> GetCategoriesAsync();
}
