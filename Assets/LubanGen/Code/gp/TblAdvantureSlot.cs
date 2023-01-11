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
   
public partial class TblAdvantureSlot
{
    private readonly Dictionary<int, gp.AdvantureSlot> _dataMap;
    private readonly List<gp.AdvantureSlot> _dataList;
    
    public TblAdvantureSlot(ByteBuf _buf)
    {
        _dataMap = new Dictionary<int, gp.AdvantureSlot>();
        _dataList = new List<gp.AdvantureSlot>();
        
        for(int n = _buf.ReadSize() ; n > 0 ; --n)
        {
            gp.AdvantureSlot _v;
            _v = gp.AdvantureSlot.DeserializeAdvantureSlot(_buf);
            _dataList.Add(_v);
            _dataMap.Add(_v.id, _v);
        }
        PostInit();
    }

    public Dictionary<int, gp.AdvantureSlot> DataMap => _dataMap;
    public List<gp.AdvantureSlot> DataList => _dataList;

    public gp.AdvantureSlot GetOrDefault(int key) => _dataMap.TryGetValue(key, out var v) ? v : null;
    public gp.AdvantureSlot Get(int key) => _dataMap[key];
    public gp.AdvantureSlot this[int key] => _dataMap[key];

    public void Resolve(Dictionary<string, object> _tables)
    {
        foreach(var v in _dataList)
        {
            v.Resolve(_tables);
        }
        PostResolve();
    }

    public void TranslateText(System.Func<string, string, string> translator)
    {
        foreach(var v in _dataList)
        {
            v.TranslateText(translator);
        }
    }
    
    partial void PostInit();
    partial void PostResolve();
}

}