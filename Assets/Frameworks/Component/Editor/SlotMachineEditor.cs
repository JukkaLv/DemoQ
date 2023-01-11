using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEditor;

public class SlotMachineEditor
{
    [MenuItem("GameObject/UI/Slot Machine", true)]
    private static bool SelectionHasCanvasValidate()
    {
        return Selection.activeGameObject && Selection.activeGameObject.GetComponentInParent<Canvas>();
    }

    [MenuItem("GameObject/UI/Slot Machine", priority = 10)]
    public static void CreateSlotMachine(MenuCommand menuCommand)
    {
        GameObject parentGO = Selection.activeGameObject;
        if (parentGO == null)
        {
            parentGO = Selection.activeGameObject.GetComponentInParent<Canvas>().gameObject;
        }

        GameObject go = new GameObject("slot_machine");

        // GameObjectUtility.SetParentAndAlign(go, menuCommand.context as GameObject); //todo Selection.activeGameObject = null 时自动找到场景中的Canvas

        go.transform.SetParent(parentGO.transform, false);
        RectTransform rectTrans = go.AddComponent<RectTransform>();
        rectTrans.sizeDelta = new Vector2(120, 180);
        SlotMachine slotMachine = go.AddComponent<SlotMachine>();

        GameObject bgGO = new GameObject("bg");
        bgGO.transform.SetParent(go.transform, false);
        Image img = bgGO.AddComponent<Image>();
        img.color = Color.black;
        rectTrans = bgGO.GetComponent<RectTransform>();
        rectTrans.anchorMin = Vector2.zero;
        rectTrans.anchorMax = Vector2.one;
        rectTrans.offsetMin = Vector2.zero;
        rectTrans.offsetMax = Vector2.zero;

        GameObject maskGO = new GameObject("mask");
        maskGO.transform.SetParent(go.transform, false);
        maskGO.AddComponent<Image>();
        Mask mask = maskGO.AddComponent<Mask>();
        mask.showMaskGraphic = false;
        rectTrans = maskGO.GetComponent<RectTransform>();
        rectTrans.anchorMin = Vector2.zero;
        rectTrans.anchorMax = Vector2.one;
        rectTrans.offsetMin = Vector2.zero;
        rectTrans.offsetMax = Vector2.zero;

        GameObject containerGO = new GameObject("container");
        containerGO.transform.SetParent(maskGO.transform, false);
        ContentSizeFitter sizeFitter = containerGO.AddComponent<ContentSizeFitter>();
        sizeFitter.horizontalFit = ContentSizeFitter.FitMode.PreferredSize;
        sizeFitter.verticalFit = ContentSizeFitter.FitMode.PreferredSize;
        VerticalLayoutGroup vLayout = containerGO.AddComponent<VerticalLayoutGroup>();
        vLayout.spacing = 20;
        vLayout.childAlignment = TextAnchor.UpperCenter;
        vLayout.childForceExpandWidth = false;
        vLayout.childForceExpandHeight = false;
        slotMachine.itemContainer = containerGO.GetComponent<RectTransform>();

        for (int i = 0; i < 3; i++)
        {
            GameObject itemGO = new GameObject("img_item" + i);
            itemGO.transform.SetParent(containerGO.transform, false);
            slotMachine.dynamicImages.Add(itemGO.AddComponent<Image>());
        }

        Undo.RegisterCreatedObjectUndo(go, "Create Slot Machine");
        Selection.activeGameObject = go;
    }
}
