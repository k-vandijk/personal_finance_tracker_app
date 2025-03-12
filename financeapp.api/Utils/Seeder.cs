using financeapp.api.Entities;

namespace financeapp.api.Utils;

public class Seeder
{
    public static async Task SeedCategoriesAsync(DataContext context)
    {
        if (context.Categories.Any())
        {
            return;
        }

        var categories = new List<Category>
            {
                new Category { Name = "Guitars"},
                new Category { Name = "Amplifiers"},
                new Category { Name = "Effects"},
                new Category { Name = "Synthesizers"},
                new Category { Name = "Other"},
            };

        await context.Categories.AddRangeAsync(categories);
        await context.SaveChangesAsync();
    }
}
