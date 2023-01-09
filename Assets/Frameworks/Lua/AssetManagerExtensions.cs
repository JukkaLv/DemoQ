using Framework.Asset;
using UnityEngine;

namespace Framework.Lua
{
    public static class AssetManagerExtensions
    {
        public static IAssetRequest<GameObject> LoadPrefab(this AssetManager assetManager, string assetPath)
        {
            return assetManager.LoadAsset<GameObject>(assetPath);
        }

        public static IAssetRequest<GameObject> LoadPrefabAsync(this AssetManager assetManager, string assetPath)
        {
            return assetManager.LoadAssetAsync<GameObject>(assetPath);
        }

        public static IAssetRequest<Sprite> LoadSprite(this AssetManager assetManager, string assetPath)
        {
            return assetManager.LoadAsset<Sprite>(assetPath);
        }

        public static IAssetRequest<Sprite> LoadSpriteAsync(this AssetManager assetManager, string assetPath)
        {
            return assetManager.LoadAssetAsync<Sprite>(assetPath);
        }

        public static IAssetRequest<Texture2D> LoadTexture(this AssetManager assetManager, string assetPath)
        {
            return assetManager.LoadAsset<Texture2D>(assetPath);
        }

        public static IAssetRequest<Texture2D> LoadTextureAsync(this AssetManager assetManager, string assetPath)
        {
            return assetManager.LoadAssetAsync<Texture2D>(assetPath);
        }
    }
}
