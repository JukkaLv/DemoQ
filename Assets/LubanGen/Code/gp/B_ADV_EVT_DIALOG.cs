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
public sealed partial class B_ADV_EVT_DIALOG :  gp.B_ADV_EVT 
{
    public B_ADV_EVT_DIALOG(ByteBuf _buf)  : base(_buf) 
    {
        dialog = _buf.ReadString();
        PostInit();
    }

    public static B_ADV_EVT_DIALOG DeserializeB_ADV_EVT_DIALOG(ByteBuf _buf)
    {
        return new gp.B_ADV_EVT_DIALOG(_buf);
    }

    public string dialog { get; private set; }

    public const int __ID__ = 517998194;
    public override int GetTypeId() => __ID__;

    public override void Resolve(Dictionary<string, object> _tables)
    {
        base.Resolve(_tables);
        PostResolve();
    }

    public override void TranslateText(System.Func<string, string, string> translator)
    {
        base.TranslateText(translator);
    }

    public override string ToString()
    {
        return "{ "
        + "dialog:" + dialog + ","
        + "}";
    }
    
    partial void PostInit();
    partial void PostResolve();
}

}