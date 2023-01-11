using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using System;

namespace UnityEngine.UI
{
    public class SlotMachine : MonoBehaviour
    {
        public RectTransform itemContainer;
        public List<Image> dynamicImages = new List<Image>();
        public List<Sprite> itemSprites = new List<Sprite>();
        public float maxSpeed = 10f;
        public float speedUp = 1f;
        public bool reverseDirection = false;
        public event Action<int> onRollingOver;

        private float offset = 0;   // 数据索引为单位，整数表示对应索引item居中
        private int midOffset = 0;  // 数据索引为单位，当前动态状态下，最中间的item对应的offset值
        private float speed = 0f;    // 转动速度

        private Vector2 machineSize;     // slot控件size
        private Vector2 itemSize;        // 单个item的size
        private float itemSpacing;       // item之间的间隔
        private float itemCenterGap;     // item中心之间的距离
        private float viewLimit;         // 视口上下偏移位置的限制范围，超过需要进行动态状态计算，更新midOffset
        private int midItemIdx;          // items列表的中位item索引，items列表需要为奇数

        void Awake()
        {
            if (dynamicImages.Count % 2 == 0)
            {
                throw new System.Exception("The count of dynamicImages in SlotMachine must be odd.");
            }
            machineSize = (transform as RectTransform).sizeDelta;
            itemSize = dynamicImages[0].rectTransform.sizeDelta;
            itemSpacing = itemContainer.GetComponent<VerticalLayoutGroup>().spacing;
            itemCenterGap = itemSize.y + itemSpacing;
            viewLimit = itemSize.y * dynamicImages.Count * 0.5f + itemSpacing * Mathf.Floor(dynamicImages.Count * 0.5f) - machineSize.y * 0.5f;
            midItemIdx = Mathf.FloorToInt(dynamicImages.Count * 0.5f);
        }

        public void Roll()
        {
            DOTween.To(() => speed, (value) => speed = value, reverseDirection ? maxSpeed : -maxSpeed, speedUp).SetEase(Ease.InBack);
        }

        public void Stop(int targetIdx)
        {
            int targetItemIdx = targetIdx;
            if (targetIdx < 0 || itemSprites.Count <= targetIdx)
            {
                //如果target索引不在范围内，则认为真随机
                targetItemIdx = Random.Range(0, itemSprites.Count);
            }
            speed = 0;
            offset = targetItemIdx + (reverseDirection ? -1 : 1) * (maxSpeed * 0.1f);
            DOTween.To(() => offset, (value) => offset = value, targetItemIdx, 1).SetEase(Ease.OutBack).OnComplete(()=>{
                if (onRollingOver != null) onRollingOver(targetItemIdx);
            });
        }

        void Calculate(float absPosY, out int stepNum, out float newAbsPosY)
        {
            // 计算需要递进的item数量
            // 先排除越界的非整数部分，整数部分除法进行递进，最后+1用来先给非整数部分递进一个，之后再计算非整数部分递进后的新偏移
            stepNum = Mathf.FloorToInt((absPosY - viewLimit) / itemCenterGap) + 1;
            // 位置同样先去掉整数部分
            newAbsPosY = absPosY % itemCenterGap;
            // 非整数部分进行递进后的偏移计算
            newAbsPosY = newAbsPosY - itemCenterGap;
            // Debug.Log(pos.y);
        }

        void Update()
        {
            Vector3 pos = itemContainer.localPosition;
            pos.y = (offset - midOffset) * (itemSize.y + itemSpacing);

            if (pos.y > viewLimit)
            {
                Calculate(pos.y, out int stepNum, out float newPosY);
                midOffset += stepNum;
                pos.y = newPosY;

            }
            else if (pos.y < -viewLimit)
            {
                Calculate(-pos.y, out int stepNum, out float newPosY);
                midOffset -= stepNum;
                pos.y = -newPosY;
            }

            // 更新动态item组里的图片
            for (int i = 0; i < dynamicImages.Count; i++)
            {
                int idxDiff = i - midItemIdx;
                int dataIdx = (midOffset + idxDiff) % itemSprites.Count;
                if (dataIdx < 0) dataIdx += itemSprites.Count;
                else if (dataIdx >= itemSprites.Count) dataIdx -= itemSprites.Count;
                dynamicImages[i].sprite = itemSprites[dataIdx];
            }

            itemContainer.localPosition = pos;

            offset += Time.deltaTime * speed;
        }
    }
}
