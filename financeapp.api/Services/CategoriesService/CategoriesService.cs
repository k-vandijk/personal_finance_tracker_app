using AutoMapper;
using financeapp.api.DTOs;
using Microsoft.EntityFrameworkCore;

namespace financeapp.api.Services.CategoriesService;

public class CategoriesService : ICategoriesService
{
    private readonly DataContext _context;
    private readonly IMapper _mapper;

    public CategoriesService(DataContext context, IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    public async Task<IEnumerable<CategoryDTO>> GetCategoriesAsync()
    {
        IEnumerable<CategoryDTO> categories = await _context.Categories
            .Select(c => _mapper.Map<CategoryDTO>(c))
            .ToListAsync();

        return categories;
    }
}
