local CommonUtils = {}

function CommonUtils.CompareTwoLists(listA, listB)
    if #listA ~= #listB then return false end
    for i=1,#listA do
        if listA[i] ~= listB[i] then return false end
    end
    return true
end

function CommonUtils.SafeMultiply(a, b, protection)
    return math.floor(a * b + (protection ~= nil and protection or 0.000001))
end

function CommonUtils.ShallowCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function CommonUtils.DeepCopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function CommonUtils.CreateArray(length, default)
    local array = {}
    for i=1,length do
        array[i] = default
    end
    return array
end

function CommonUtils.IndexOf(array, target)
    assert(array ~= nil, "CommonUtils.FindArrayElements -> array is nil.")
    local results = {}
    local target_type = type(target)
    if target_type == 'function' then
        for i,v in ipairs(array) do
            if target(v) then
                table.insert(results, i)
            end
        end
    else
        for i,v in ipairs(array) do
            if v == target then
                table.insert(results, i)
            end
        end
    end
    return results
end

-- 遍历判断条件
function CommonUtils.TestEverybodyInList(list, testfunc, tester, mode) -- mode 1全部满足, 2任意满足
    assert(list ~= nil, "CommonUtils.CommonUtils.TestEverybodyInList -> list is nil.")
    assert(testfunc ~= nil, "CommonUtils.CommonUtils.TestEverybodyInList -> testfunc is nil.")
    assert(mode == 1 or mode == 2, "CommonUtils.CommonUtils.TestEverybodyInList -> mode is invalid: "..tostring(mode))

    local result = mode == 1
    for _,body in ipairs(list) do
        local b
        if tester == nil then b = testfunc(body)
        else b = testfunc(tester, body) end

        if mode == 1 then result = result and b
        else result = result or b end

        -- 短路一下，节省计算
        if mode == 1 and result == false then return false end
        if mode == 2 and result == true then return true end
    end
    return result
end

return CommonUtils