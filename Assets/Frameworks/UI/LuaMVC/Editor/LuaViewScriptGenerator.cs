using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using Framework.Lua;
using Framework.FileSys;

namespace Framework.LuaMVC.Editor
{
    public class LuaViewScriptGenerator
    {
        private static string LUA_VIEW_DIR = LuaGlobalDefine.LUA_ROOT_DIR + "MVC/View/";

        public static void Generate(LuaViewFacade facade)
        {
            _internalSubViewStack.Clear();
            _viewTblNameSet.Clear();
            StringBuilder strBuilder = new StringBuilder();
            strBuilder.AppendLine("-- 本脚本为自动生成，不要手动修改，以免被覆盖");
            strBuilder.AppendLine("local Notifier = require 'Framework.Notifier'");

            bool sucess;
            if (facade.subView) sucess = GenerateSubView(facade, ref strBuilder, false);
            else sucess = GenerateView(facade, ref strBuilder);

            if (sucess)
            {
                string path = LUA_VIEW_DIR + facade.viewName + ".lua";
                FileHelper.CreateDirectoriesByPath(path);
                if (File.Exists(path))
                {
                    if (EditorUtility.DisplayDialog("Notice", path + "\n Overwrite the exist file?", "Yes", "No")) File.Delete(path);
                }
                File.WriteAllText(path, strBuilder.ToString());
                Debug.Log("Generate Success.");
            }
        }

        private static bool ValidateFacade(LuaViewFacade facade)
        {
            if (string.IsNullOrEmpty(facade.viewName))
            {
                EditorUtility.DisplayDialog("Error!", "view name can't be empty.", "OK");
                return false;
            }

            HashSet<string> keywords = new HashSet<string>(2) { "gameObject", "transform" };
            foreach (LuaViewComponent comp in facade.comps)
            {
                if (keywords.Contains(comp.name))
                {
                    EditorUtility.DisplayDialog("Error!", comp.name + " is a keyword in generated code. can't use it as the name of component.", "OK");
                    return false;
                }
                if (!Regex.IsMatch(comp.name, "^[_a-zA-Z]+[_a-zA-Z0-9]*$"))
                {
                    EditorUtility.DisplayDialog("Error!", comp.name + " does not conform to variable naming conventions.", "OK");
                    return false;
                }
            }

            return true;
        }

        private static Stack<LuaViewFacade> _internalSubViewStack = new Stack<LuaViewFacade>();
        private static HashSet<string> _viewTblNameSet = new HashSet<string>();
        private static bool GenerateView(LuaViewFacade facade, ref StringBuilder strBuilder)
        {
            if (!ValidateFacade(facade)) return false;

            string viewTblName = GetFacadeTblName(facade);

            #region declare table
            strBuilder.AppendFormat("local {0} = ", viewTblName).AppendLine("{}");
            // strBuilder.AppendLine("local ViewBase = require 'Framework.MVC.ViewBase'");
            strBuilder.AppendFormat("{0}.__index = {0}", viewTblName).AppendLine();
            // strBuilder.AppendFormat("setmetatable({0}, ViewBase)", viewTblName).AppendLine();
            strBuilder.AppendFormat("{0}.__PREFAB_ASSET = '{1}'", viewTblName, AssetDatabase.GetAssetPath(facade)).AppendLine();
            #endregion

            GenerateViewComps(facade, out StringBuilder compsCreateBuilder, out StringBuilder compsInitBuider, out StringBuilder compsRenderBuilder);

            #region func Create
            strBuilder.AppendFormat("function {0}.Create(facade, inherit)", viewTblName).AppendLine();
            strBuilder.Append("\t").AppendLine("local copy = {}");
            strBuilder.Append("\t").AppendFormat("setmetatable(copy, {0})", viewTblName).AppendLine();
            strBuilder.Append("\t").AppendLine("copy:Init(facade)");
            strBuilder.Append("\t").AppendLine("if inherit ~= nil then");
            strBuilder.Append(compsCreateBuilder);
            strBuilder.Append("\t").AppendLine("end");
            strBuilder.Append("\t").AppendLine("return copy");
            strBuilder.AppendLine("end");
            strBuilder.AppendLine();
            #endregion

            #region func Init
            strBuilder.AppendFormat("function {0}:Init(facade)", viewTblName).AppendLine();
            strBuilder.Append("\t").AppendFormat("assert(facade ~= nil, 'Error! {0} facade is nil')", viewTblName).AppendLine();
            strBuilder.Append("\t").AppendLine("facade:SetComps(self)");
            strBuilder.Append("\t").AppendLine("self.viewName = facade.viewName");
            strBuilder.Append("\t").AppendLine("self.gameObject = facade.gameObject");
            strBuilder.Append("\t").AppendLine("self.transform = facade.transform");
            strBuilder.Append(compsInitBuider);
            strBuilder.AppendLine("end");
            strBuilder.AppendLine();
            #endregion

            #region func Open
            strBuilder.AppendFormat("function {0}:Open(viewModel)", viewTblName).AppendLine();
            strBuilder.Append("\t").AppendFormat("assert(self.gameObject ~= nil, 'Error! {0} has been disposed.')", viewTblName).AppendLine();
            strBuilder.Append("\t").AppendLine("Notifier.Dispatch('__OPEN_VIEW_BEFORE', self)");
            strBuilder.Append("\t").AppendLine("self.gameObject:SetActive(true)");
            strBuilder.Append("\t").AppendLine("if viewModel ~= nil then self:Render(viewModel) end");
            strBuilder.Append("\t").AppendLine("Notifier.Dispatch('__OPEN_VIEW_AFTER', self)");
            strBuilder.AppendLine("end");
            strBuilder.AppendLine();
            #endregion

            #region func Close
            strBuilder.AppendFormat("function {0}:Close()", viewTblName).AppendLine();
            strBuilder.Append("\t").AppendFormat("assert(self.gameObject ~= nil, 'Error! {0} has been disposed.')", viewTblName).AppendLine();
            strBuilder.Append("\t").AppendLine("Notifier.Dispatch('__CLOSE_VIEW_BEFORE', self)");
            strBuilder.Append("\t").AppendLine("self.gameObject:SetActive(false)");
            strBuilder.Append("\t").AppendLine("Notifier.Dispatch('__CLOSE_VIEW_AFTER', self)");
            strBuilder.AppendLine("end");
            strBuilder.AppendLine();
            #endregion

            #region func Dispose
            strBuilder.AppendFormat("function {0}:Dispose()", viewTblName).AppendLine();
            strBuilder.Append("\t").AppendFormat("assert(self.gameObject ~= nil, 'Error! {0} has been disposed.')", viewTblName).AppendLine();
            strBuilder.Append("\t").AppendLine("GameObject.Destroy(self.gameObject)");
            strBuilder.Append("\t").AppendLine("self.gameObject = nil");
            strBuilder.Append("\t").AppendLine("self.transform = nil");
            strBuilder.AppendLine("end");
            strBuilder.AppendLine();
            #endregion

            #region func Render
            strBuilder.AppendFormat("function {0}:Render(viewModel)", viewTblName).AppendLine();
            strBuilder.Append("\t").AppendFormat("assert(viewModel ~= nil, 'Error! {0} view model is nil')", viewTblName).AppendLine();
            strBuilder.Append(compsRenderBuilder);
            strBuilder.AppendLine("end");
            strBuilder.AppendLine();
            #endregion

            #region internal sub views
            while (_internalSubViewStack.Count > 0)
            {
                LuaViewFacade internalFacade = _internalSubViewStack.Pop();
                if (!GenerateSubView(internalFacade, ref strBuilder, true)) return false;
            }
            #endregion

            #region final return
            strBuilder.AppendFormat("return {0}", viewTblName);
            #endregion

            return true;
        }

        private static bool GenerateSubView(LuaViewFacade facade, ref StringBuilder strBuilder, bool isInternal)
        {
            if (!ValidateFacade(facade)) return false;

            string viewTblName = GetFacadeTblName(facade);
            if (_viewTblNameSet.Contains(viewTblName))
            {
                EditorUtility.DisplayDialog("Error!", "detected same name of sub facade: " + viewTblName, "OK");
                return false;
            }
            _viewTblNameSet.Add(viewTblName);

            if (isInternal) strBuilder.Append("-- Auto Generate Internal View: ").AppendLine(viewTblName);
            #region declare table
            if (isInternal) strBuilder.AppendFormat("{0} = ", viewTblName).AppendLine("{}");
            else strBuilder.AppendFormat("local {0} = ", viewTblName).AppendLine("{}");
            strBuilder.AppendFormat("{0}.__index = {0}", viewTblName).AppendLine();
            if (!isInternal) strBuilder.AppendFormat("{0}.__PREFAB_ASSET = '{1}'", viewTblName, AssetDatabase.GetAssetPath(facade)).AppendLine();
            strBuilder.AppendLine();
            #endregion

            GenerateViewComps(facade, out StringBuilder compsCreateBuilder, out StringBuilder compsInitBuilder, out StringBuilder compsRenderBuilder);

            #region func Create
            strBuilder.AppendFormat("function {0}.Create(facade, inherit)", viewTblName).AppendLine();
            strBuilder.Append("\t").AppendLine("local copy = {}");
            strBuilder.Append("\t").AppendFormat("setmetatable(copy, {0})", viewTblName).AppendLine();
            strBuilder.Append("\t").AppendLine("copy:Init(facade)");
            strBuilder.Append("\t").AppendLine("if inherit ~= nil then");
            strBuilder.Append(compsCreateBuilder);
            strBuilder.Append("\t").AppendLine("end");
            strBuilder.Append("\t").AppendLine("return copy");
            strBuilder.AppendLine("end");
            strBuilder.AppendLine();
            #endregion

            #region func Init
            strBuilder.AppendFormat("function {0}:Init(facade)", viewTblName).AppendLine();
            strBuilder.Append("\t").AppendFormat("assert(facade ~= nil, 'Error! {0} facade is nil')", viewTblName).AppendLine();
            strBuilder.Append("\t").AppendLine("facade:SetComps(self)");
            strBuilder.Append("\t").AppendLine("self.viewName = facade.viewName");
            strBuilder.Append("\t").AppendLine("self.gameObject = facade.gameObject");
            strBuilder.Append("\t").AppendLine("self.transform = facade.transform");
            strBuilder.Append(compsInitBuilder);
            strBuilder.AppendLine("end");
            strBuilder.AppendLine();
            #endregion

            #region func Render
            strBuilder.AppendFormat("function {0}:Render(viewModel)", viewTblName).AppendLine();
            strBuilder.Append("\t").AppendFormat("assert(viewModel ~= nil, 'Error! {0} view model is nil')", viewTblName).AppendLine();
            strBuilder.Append(compsRenderBuilder);
            strBuilder.AppendLine("end");
            strBuilder.AppendLine();
            #endregion

            #region internal sub views
            while (_internalSubViewStack.Count > 0)
            {
                LuaViewFacade internalFacade = _internalSubViewStack.Pop();
                if (!GenerateSubView(internalFacade, ref strBuilder, true)) return false;
            }
            #endregion

            if (!isInternal)
            {
                #region final return
                strBuilder.AppendFormat("return {0}", facade.viewName);
                #endregion
            }
            
            return true;
        }

        private static string GetFacadeTblName(LuaViewFacade facade)
        {
            Stack<string> stack = new Stack<string>();
            stack.Push(facade.viewName);

            Transform node = facade.transform.parent;
            while (node != null)
            {
                LuaViewFacade pFacade = node.GetComponent<LuaViewFacade>();
                if (pFacade != null) stack.Push(pFacade.viewName);
                node = node.parent;
            }
            return string.Join('.', stack);
        }

        private static void GenerateViewComps(LuaViewFacade facade, out StringBuilder createBuilder, out StringBuilder initBuilder, out StringBuilder renderBuilder)
        {
            createBuilder = new StringBuilder();
            initBuilder = new StringBuilder();
            renderBuilder = new StringBuilder();
            foreach (LuaViewComponent comp in facade.comps)
            {
                switch (comp.type)
                {
                    case "Object":
                        renderBuilder.Append("\t").AppendFormat("if viewModel.{0} ~= nil then", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.actived ~= nil then self.{0}:SetActive(viewModel.{0}.actived) end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.position ~= nil then self.{0}.transform.localPosition = viewModel.{0}.position end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.rotation ~= nil then self.{0}.transform.localRotation = viewModel.{0}.rotation end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.euler ~= nil then self.{0}.transform.localEulerAngles = viewModel.{0}.euler end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.scale ~= nil then self.{0}.transform.localScale = viewModel.{0}.scale end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.parent ~= nil then self.{0}.transform.parent = viewModel.{0}.parent end", comp.name).AppendLine();
                        renderBuilder.Append("\t").AppendLine("end");
                        break;
                    case "LuaViewFacade":
                        initBuilder.Append("\t").AppendFormat("self.{0} = {1}.{2}.Create(self.view_xxx)", comp.name, facade.viewName, ((LuaViewFacade)comp.target).viewName).AppendLine();
                        renderBuilder.Append("\t").AppendFormat("if viewModel.{0} ~= nil then", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("self.{0}:Render(viewModel.{0})", comp.name).AppendLine();
                        renderBuilder.Append("\t").AppendLine("end");
                        _internalSubViewStack.Push((LuaViewFacade)comp.target);
                        break;
                    case "Image":
                        renderBuilder.Append("\t").AppendFormat("if viewModel.{0} ~= nil then", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.enabled ~= nil then self.{0}.enabled = viewModel.{0}.enabled end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.color ~= nil then self.{0}.color = viewModel.{0}.color end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.sprite ~= nil then self.{0}.sprite = viewModel.{0}.sprite end", comp.name).AppendLine();
                        renderBuilder.Append("\t").AppendLine("end");
                        break;
                    case "RawImage":
                        renderBuilder.Append("\t").AppendFormat("if viewModel.{0} ~= nil then", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.enabled ~= nil then self.{0}.enabled = viewModel.{0}.enabled end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.color ~= nil then self.{0}.color = viewModel.{0}.color end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.texture ~= nil then self.{0}.texture = viewModel.{0}.texture end", comp.name).AppendLine();
                        renderBuilder.Append("\t").AppendLine("end");
                        break;
                    case "Text":
                    case "TextMeshProUGUI":
                        // if (!string.IsNullOrEmpty(comp.paramStr)) initBuilder.Append("\t").AppendFormat("self.{0}.text = 'Static Label' -- lookup language table later.", comp.name).AppendLine();
                        renderBuilder.Append("\t").AppendFormat("if viewModel.{0} ~= nil then", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.enabled ~= nil then self.{0}.enabled = viewModel.{0}.enabled end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.text ~= nil then self.{0}.text = viewModel.{0}.text end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.color ~= nil then self.{0}.color = viewModel.{0}.color end", comp.name).AppendLine();
                        renderBuilder.Append("\t").AppendLine("end");
                        break;
                    case "InputField":
                    case "TMP_InputField":
                        initBuilder.Append("\t").AppendFormat("self.{0}_OnValueChanged = nil", comp.name).AppendLine();
                        initBuilder.Append("\t").AppendFormat("self.{0}.onValueChanged:AddListener(function(text) if self.{0}_OnValueChanged ~= nil then self.{0}_OnValueChanged(text) end end)", comp.name).AppendLine();
                        initBuilder.Append("\t").AppendFormat("self.{0}_OnSubmit = nil", comp.name).AppendLine();
                        initBuilder.Append("\t").AppendFormat("self.{0}.onSubmit:AddListener(function(text) if self.{0}_OnSubmit ~= nil then self.{0}_OnSubmit(text) end end)", comp.name).AppendLine();
                        renderBuilder.Append("\t").AppendFormat("if viewModel.{0} ~= nil then", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.enabled ~= nil then self.{0}.enabled = viewModel.{0}.enabled end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.interactable ~= nil then self.{0}.interactable = viewModel.{0}.interactable end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.text ~= nil then self.{0}.text = viewModel.{0}.text end", comp.name).AppendLine();
                        renderBuilder.Append("\t").AppendLine("end");
                        break;
                    case "Toggle":
                        initBuilder.Append("\t").AppendFormat("self.{0}_OnValueChanged = nil", comp.name).AppendLine();
                        initBuilder.Append("\t").AppendFormat("self.{0}.onValueChanged:AddListener(function(isOn) if self.{0}_OnValueChanged ~= nil then self.{0}_OnValueChanged(isOn) end end)", comp.name).AppendLine();
                        renderBuilder.Append("\t").AppendFormat("if viewModel.{0} ~= nil then", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.enabled ~= nil then self.{0}.enabled = viewModel.{0}.enabled end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.interactable ~= nil then self.{0}.interactable = viewModel.{0}.interactable end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.isOn ~= nil then self.{0}.isOn = viewModel.{0}.isOn end", comp.name).AppendLine();
                        renderBuilder.Append("\t").AppendLine("end");
                        break;
                    case "ToggleGroup":
                        break;
                    case "Button":
                        initBuilder.Append("\t").AppendFormat("self.{0}_OnClick = nil", comp.name).AppendLine();
                        initBuilder.Append("\t").AppendFormat("self.{0}_OnClickNoti = nil", comp.name).AppendLine();
                        initBuilder.Append("\t").AppendFormat("self.{0}.onClick:AddListener(function()", comp.name).AppendLine();
                        initBuilder.Append("\t\t").AppendFormat("if self.{0}_OnClick ~= nil then self.{0}_OnClick() end", comp.name).AppendLine();
                        initBuilder.Append("\t\t").AppendFormat("if self.{0}_OnClickNoti ~= nil and self.{0}_OnClickNoti.name ~= nil then Notifier.Dispatch(self.{0}_OnClickNoti.name, self.{0}_OnClickNoti.body) end ", comp.name).AppendLine();
                        initBuilder.Append("\t").AppendLine("end)");
                        renderBuilder.Append("\t").AppendFormat("if viewModel.{0} ~= nil then", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.enabled ~= nil then self.{0}.enabled = viewModel.{0}.enabled end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.interactable ~= nil then self.{0}.interactable = viewModel.{0}.interactable end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.OnClickNoti ~= nil then self.{0}_OnClickNoti = viewModel.{0}.OnClickNoti end", comp.name).AppendLine();
                        renderBuilder.Append("\t").AppendLine("end");
                        break;
                    case "Slider":
                        initBuilder.Append("\t").AppendFormat("self.{0}_OnValueChanged = nil", comp.name).AppendLine();
                        initBuilder.Append("\t").AppendFormat("self.{0}.onValueChanged:AddListener(function(value) if self.{0}_OnValueChanged ~= nil then self.{0}_OnValueChanged(value) end end)", comp.name).AppendLine();
                        renderBuilder.Append("\t").AppendFormat("if viewModel.{0} ~= nil then", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.enabled ~= nil then self.{0}.enabled = viewModel.{0}.enabled end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.interactable ~= nil then self.{0}.interactable = viewModel.{0}.interactable end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.value ~= nil then self.{0}.value = viewModel.{0}.value end", comp.name).AppendLine();
                        renderBuilder.Append("\t").AppendLine("end");
                        break;
                    case "Scrollbar":
                        initBuilder.Append("\t").AppendFormat("self.{0}_OnValueChanged = nil", comp.name).AppendLine();
                        initBuilder.Append("\t").AppendFormat("self.{0}.onValueChanged:AddListener(function(value) if self.{0}_OnValueChanged ~= nil then self.{0}_OnValueChanged(value) end end)", comp.name).AppendLine();
                        renderBuilder.Append("\t").AppendFormat("if viewModel.{0} ~= nil then", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.enabled ~= nil then self.{0}.enabled = viewModel.{0}.enabled end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.interactable ~= nil then self.{0}.interactable = viewModel.{0}.interactable end", comp.name).AppendLine();
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.value ~= nil then self.{0}.value = viewModel.{0}.value end", comp.name).AppendLine();
                        renderBuilder.Append("\t").AppendLine("end");
                        break;
                    case "LayoutGroup":
                        createBuilder.Append("\t\t").AppendFormat("copy.{0}_ItemTemplate = inherit.{0}_ItemTemplate", comp.name).AppendLine();  // 列表项模板需要逐层传递
                        initBuilder.Append("\t").AppendFormat("self.{0}_ItemTemplate = nil", comp.name).AppendLine(); // 列表项模板
                        initBuilder.Append("\t").AppendFormat("self.__{0}_POOL = {1}", comp.name, "{}").AppendLine(); // 列表内部池
                        renderBuilder.Append("\t").AppendFormat("if viewModel.{0} ~= nil then", comp.name).AppendLine();
                        // items
                        renderBuilder.Append("\t\t").AppendFormat("if viewModel.{0}.items ~= nil then", comp.name).AppendLine();
                        renderBuilder.Append("\t\t\t").AppendFormat("assert(self.{0}_ItemTemplate ~= nil, '{1}.{0} item template is nil')", comp.name, facade.viewName).AppendLine();
                        renderBuilder.Append("\t\t\t").AppendFormat("local minLen = math.min(#self.__{0}_POOL, #viewModel.{0}.items)", comp.name).AppendLine();
                        renderBuilder.Append("\t\t\t").AppendLine("for i=1,minLen do");
                        renderBuilder.Append("\t\t\t\t").AppendFormat("self.__{0}_POOL[i].gameObject:SetActive(true)", comp.name).AppendLine();
                        renderBuilder.Append("\t\t\t\t").AppendFormat("self.__{0}_POOL[i]:Render(viewModel.{0}.items[i])", comp.name).AppendLine();
                        renderBuilder.Append("\t\t\t").AppendLine("end");
                        renderBuilder.Append("\t\t\t").AppendFormat("for i=minLen+1,#self.__{0}_POOL do", comp.name).AppendLine();
                        renderBuilder.Append("\t\t\t\t").AppendFormat("self.__{0}_POOL[i].gameObject:SetActive(false)", comp.name).AppendLine();
                        renderBuilder.Append("\t\t\t").AppendLine("end");
                        renderBuilder.Append("\t\t\t").AppendFormat("for i=minLen+1,#viewModel.{0}.items do", comp.name).AppendLine();
                        renderBuilder.Append("\t\t\t\t").AppendFormat("local ITEM_VIEW = require('MVC.View.'..self.{0}_ItemTemplate.viewName)", comp.name).AppendLine();
                        renderBuilder.Append("\t\t\t\t").AppendFormat("local itemViewGO = GameObject.Instantiate(self.{0}_ItemTemplate.gameObject, Vector3.zero, Quaternion.identity, self.{0}.transform)", comp.name).AppendLine();
                        renderBuilder.Append("\t\t\t\t").AppendFormat("local itemView = ITEM_VIEW.Create(itemViewGO:GetComponent('LuaViewFacade'), self.{0}_ItemTemplate)", comp.name).AppendLine();
                        renderBuilder.Append("\t\t\t\t").AppendFormat("table.insert(self.__{0}_POOL, itemView)", comp.name).AppendLine();
                        renderBuilder.Append("\t\t\t\t").AppendFormat("itemViewGO.transform:SetParent(self.{0}.transform, false)", comp.name).AppendLine();
                        renderBuilder.Append("\t\t\t\t").AppendLine("itemViewGO:SetActive(true)");
                        renderBuilder.Append("\t\t\t\t").AppendFormat("itemView:Render(viewModel.{0}.items[i])", comp.name).AppendLine();
                        renderBuilder.Append("\t\t\t").AppendLine("end");
                        renderBuilder.Append("\t\t").AppendLine("end");
                        renderBuilder.Append("\t").AppendLine("end");
                        break;
                    default:
                        Debug.LogWarning("ignored unsupport component type: " + comp.type);
                        break;
                }
            }
        }
    }
}