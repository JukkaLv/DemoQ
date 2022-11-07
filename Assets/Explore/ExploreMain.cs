using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Framework.Lua;
using System.IO;
using XLua;
using UnityEngine.UI;
using DG.Tweening;

public class ExploreMain : MonoBehaviour
{
    void Awake()
    {
        Application.targetFrameRate = 60;
        GameObject.DontDestroyOnLoad(gameObject);
    }

    void Start()
    {
        LuaManager.Instance.AddLoadPath(Application.streamingAssetsPath + "/Lua/"); // �������LaodPath������Ļ�ֱ�Ӷ���StreamingAssets�±ȽϿ�
        LuaManager.Instance.Launch("Explore/ExploreMain");
    }

    void Update()
    {

    }
}