using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TestSlotMachine : MonoBehaviour
{
    public SlotMachine slotMachine;

    void OnGUI()
    {
        if (GUI.Button(Rect.MinMaxRect(20f, 20f, 200f, 100f), "Roll"))
        {
            slotMachine.Roll();
        }

        if (GUI.Button(Rect.MinMaxRect(20f, 220f, 200f, 300f), "Stop"))
        {
            slotMachine.Stop(0);
        }
    }
}
