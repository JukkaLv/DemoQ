namespace Framework.Luban
{
    public class LubanManager
    {
        public static cfg.Tables tables;
        private static ILubanLoader _loader;

        public static void Initialize(string loadPath)
        {
            if (tables != null) throw new System.Exception("Duplicate initialize LubanTables.");
            _loader = new LubanLoader();
            _loader.AddLoadPath(loadPath);
            tables = new cfg.Tables(_loader.Load);
        }

        public static void AddLoadPath(string loadPath)
        {
            if (_loader != null) _loader.AddLoadPath(loadPath);
        }

        public static void Dispose()
        {
            tables = null;
            _loader = null;
        }
    }
}
