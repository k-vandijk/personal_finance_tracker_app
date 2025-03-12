using financeapp.api.DTOs;
using financeapp.api.Entities;

namespace financeapp.api.Services.AssetsService;

public interface IAssetsService
{
    Task<AssetDTO> CreateAssetAsync(AssetDTO dto, User currentUser);
    Task<IEnumerable<AssetDTO>> GetAssetsAsync(User currentUser);
    Task<AssetDTO> GetAssetAsync(Guid id, User currentUser);
    Task<AssetDTO> UpdateAssetAsync(Guid id, AssetDTO dto, User currentUser);
    Task<bool> DeleteAssetAsync(Guid id, User currentUser);
}
