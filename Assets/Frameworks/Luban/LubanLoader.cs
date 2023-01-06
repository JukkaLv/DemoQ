using System.Collections;
using System.Collections.Generic;
using UnityEngine.Networking;
using System.IO;
using Bright.Serialization;

namespace Framework.Luban
{
    public class LubanLoader : ILubanLoader
    {
        private List<string> _loadPaths = new List<string>();

        public void AddLoadPath(string path)
        {
            if (_loadPaths.Contains(path)) return;
            _loadPaths.Add(path);
        }

        public ByteBuf Load(string filepath)
        {
            foreach (string loadPath in _loadPaths)
            {
                string realpath = loadPath + filepath + ".bytes";
                ByteBuf bytes = TryLoad(realpath);
                if (bytes != null) return bytes;
            }
            throw new System.Exception("Can't find luban data: " + filepath);
        }

        private ByteBuf TryLoad(string filePath)
        {
            byte[] bytes = null;
            bool jar = filePath.StartsWith("jar:");
            if (jar)
            {
                using (UnityWebRequest request = UnityWebRequest.Get(filePath))
                {
                    UnityWebRequestAsyncOperation asyncOp = request.SendWebRequest();
                    while (!asyncOp.isDone) {}
                    if (string.IsNullOrEmpty(request.error)) bytes = request.downloadHandler.data;
                }
            }
            else
            {
                if (File.Exists(filePath)) bytes = File.ReadAllBytes(filePath);
            }
            // UnityEngine.Debug.Log("TRY LOAD LUA: " + filePath + " -> " + (bytes == null ? "NULL" : bytes.Length));
            return new ByteBuf(bytes);
        }
    }
}
