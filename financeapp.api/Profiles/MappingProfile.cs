using AutoMapper;
using financeapp.api.DTOs;
using financeapp.api.Entities;

namespace financeapp.api.Profiles;

public class MappingProfile : Profile
{
    public MappingProfile()
    {
        CreateMap<Asset, AssetDTO>().ReverseMap();
    }
}
