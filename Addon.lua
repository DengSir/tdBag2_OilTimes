-- Addon.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 12/24/2020, 3:37:48 PM
--
local Addon = tdBag2
if not Addon then
    return
end

if not Addon.RegisterPlugin then
    return print('You must update tdBag2 to use Oil Times')
end

local _G = _G
local UIParent = UIParent

local tonumber = tonumber

local BankButtonIDToInvSlotID = BankButtonIDToInvSlotID

local ITEM_SPELL_CHARGES_M = ITEM_SPELL_CHARGES:gsub('%%d', '(%%d+)')
local BANK_CONTAINER = BANK_CONTAINER

local TimesScaner = CreateFrame('GameTooltip', 'tdBag2TimesScaner', UIParent, 'GameTooltipTemplate')

local ITEMS = {
    [20748] = true,
    [20749] = true,
    [20750] = true,
    [20747] = true,
    [20746] = true,
    [20745] = true,
    [20744] = true,
}

-- @bcc@
ITEMS[22522] = true
ITEMS[22521] = true
ITEMS[22044] = true

ITEMS[34538] = true
ITEMS[34539] = true
-- @end-bcc@

local function GetTimes(bag, slot)
    TimesScaner:SetOwner(UIParent, 'ANCHOR_NONE')
    if bag == BANK_CONTAINER then
        TimesScaner:SetInventoryItem('player', BankButtonIDToInvSlotID(slot))
    else
        TimesScaner:SetBagItem(bag, slot)
    end

    for i = 1, TimesScaner:NumLines() do
        local textLeft = _G['tdBag2TimesScanerTextLeft' .. i]
        local times = tonumber(textLeft:GetText():match(ITEM_SPELL_CHARGES_M))

        if times then
            return times
        end
    end
end

local function UpdateItem(item)
    if not ITEMS[item.info.id] or item.meta:IsCached() then
        return
    end

    local times = GetTimes(item.bag, item.slot)
    if times then
        item.Count:SetFormattedText('|cff00ff00%d|r', times)
        item.Count:Show()
    end
end

Addon:RegisterPlugin{type = 'Item', update = UpdateItem}
