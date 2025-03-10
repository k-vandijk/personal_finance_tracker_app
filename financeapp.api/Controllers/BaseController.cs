using Microsoft.AspNetCore.Mvc;

namespace financeapp.api.Controllers;

public class BaseController : Controller
{
    private readonly DataContext _context;

    public BaseController(DataContext context)
    {
        _context = context;
    }
}
