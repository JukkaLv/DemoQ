using Bright.Serialization;

namespace Framework.Luban
{
    public interface ILubanLoader
    {
        void AddLoadPath(string path);
        ByteBuf Load(string filepath);
    }
}
