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
public sealed partial class Skill :  Bright.Config.BeanBase 
{
    public Skill(ByteBuf _buf) 
    {
        id = _buf.ReadInt();
        name = _buf.ReadString();
        startCD = _buf.ReadInt();
        intervalCD = _buf.ReadInt();
        priority = _buf.ReadInt();
        power = _buf.ReadInt();
        type = (gp.E_BattleSkillType)_buf.ReadInt();
        {int n0 = System.Math.Min(_buf.ReadSize(), _buf.Size);elements = new System.Collections.Generic.List<gp.E_Element>(n0);for(var i0 = 0 ; i0 < n0 ; i0++) { gp.E_Element _e0;  _e0 = (gp.E_Element)_buf.ReadInt(); elements.Add(_e0);}}
        if(_buf.ReadBool()){ enterAction = _buf.ReadString(); } else { enterAction = null; }
        if(_buf.ReadBool()){ castAction = _buf.ReadString(); } else { castAction = null; }
        targetFilter = gp.B_TF.DeserializeB_TF(_buf);
        targetSelector = gp.B_TS.DeserializeB_TS(_buf);
        desc = _buf.ReadString();
        PostInit();
    }

    public static Skill DeserializeSkill(ByteBuf _buf)
    {
        return new gp.Skill(_buf);
    }

    /// <summary>
    /// 主键ID
    /// </summary>
    public int id { get; private set; }
    /// <summary>
    /// 名称
    /// </summary>
    public string name { get; private set; }
    /// <summary>
    /// 初始CD
    /// </summary>
    public int startCD { get; private set; }
    /// <summary>
    /// 间隔CD
    /// </summary>
    public int intervalCD { get; private set; }
    /// <summary>
    /// 优先级
    /// </summary>
    public int priority { get; private set; }
    /// <summary>
    /// 威力
    /// </summary>
    public int power { get; private set; }
    /// <summary>
    /// 技能类型
    /// </summary>
    public gp.E_BattleSkillType type { get; private set; }
    /// <summary>
    /// 元素(转盘结果 or 普通产生)
    /// </summary>
    public System.Collections.Generic.List<gp.E_Element> elements { get; private set; }
    /// <summary>
    /// 开场ACTION
    /// </summary>
    public string enterAction { get; private set; }
    /// <summary>
    /// 施放ACTION
    /// </summary>
    public string castAction { get; private set; }
    /// <summary>
    /// 技能目标筛选器
    /// </summary>
    public gp.B_TF targetFilter { get; private set; }
    /// <summary>
    /// 技能目标选择器
    /// </summary>
    public gp.B_TS targetSelector { get; private set; }
    /// <summary>
    /// 技能描述
    /// </summary>
    public string desc { get; private set; }

    public const int __ID__ = 1133887724;
    public override int GetTypeId() => __ID__;

    public  void Resolve(Dictionary<string, object> _tables)
    {
        targetFilter?.Resolve(_tables);
        targetSelector?.Resolve(_tables);
        PostResolve();
    }

    public  void TranslateText(System.Func<string, string, string> translator)
    {
        targetFilter?.TranslateText(translator);
        targetSelector?.TranslateText(translator);
    }

    public override string ToString()
    {
        return "{ "
        + "id:" + id + ","
        + "name:" + name + ","
        + "startCD:" + startCD + ","
        + "intervalCD:" + intervalCD + ","
        + "priority:" + priority + ","
        + "power:" + power + ","
        + "type:" + type + ","
        + "elements:" + Bright.Common.StringUtil.CollectionToString(elements) + ","
        + "enterAction:" + enterAction + ","
        + "castAction:" + castAction + ","
        + "targetFilter:" + targetFilter + ","
        + "targetSelector:" + targetSelector + ","
        + "desc:" + desc + ","
        + "}";
    }
    
    partial void PostInit();
    partial void PostResolve();
}

}