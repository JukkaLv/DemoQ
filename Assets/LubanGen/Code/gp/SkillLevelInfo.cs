//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------
using Bright.Serialization;
using System.Collections.Generic;


namespace cfg.gp
{
public sealed partial class SkillLevelInfo :  Bright.Config.BeanBase 
{
    public SkillLevelInfo(ByteBuf _buf) 
    {
        Level = _buf.ReadInt();
        Exp = _buf.ReadInt();
        PostInit();
    }

    public static SkillLevelInfo DeserializeSkillLevelInfo(ByteBuf _buf)
    {
        return new gp.SkillLevelInfo(_buf);
    }

    public int Level { get; private set; }
    public int Exp { get; private set; }

    public const int __ID__ = 1363917510;
    public override int GetTypeId() => __ID__;

    public  void Resolve(Dictionary<string, object> _tables)
    {
        PostResolve();
    }

    public  void TranslateText(System.Func<string, string, string> translator)
    {
    }

    public override string ToString()
    {
        return "{ "
        + "Level:" + Level + ","
        + "Exp:" + Exp + ","
        + "}";
    }
    
    partial void PostInit();
    partial void PostResolve();
}

}