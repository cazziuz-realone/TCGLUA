-- Card Entity Module
-- Represents a card in the SpireSmiths TCG
-- Converted from Kotlin domain entities to Lua

local M = {}

-- Card types
M.CARD_TYPES = {
    CREATURE = "creature",
    SPELL = "spell",
    WEAPON = "weapon"
}

-- Card rarities
M.RARITIES = {
    COMMON = { id = "common", name = "Common", color = "#9E9E9E" },
    RARE = { id = "rare", name = "Rare", color = "#2196F3" },
    EPIC = { id = "epic", name = "Epic", color = "#9C27B0" },
    LEGENDARY = { id = "legendary", name = "Legendary", color = "#FF9800" }
}

-- Card keywords
M.KEYWORDS = {
    TAUNT = { id = "taunt", name = "Taunt", description = "Enemies must attack this creature first" },
    CHARGE = { id = "charge", name = "Charge", description = "Can attack immediately" },
    DIVINE_SHIELD = { id = "divine_shield", name = "Divine Shield", description = "Prevents the first damage taken" },
    STEALTH = { id = "stealth", name = "Stealth", description = "Cannot be attacked until this creature attacks" },
    LIFESTEAL = { id = "lifesteal", name = "Lifesteal", description = "Damage dealt heals your hero" },
    WINDFURY = { id = "windfury", name = "Windfury", description = "Can attack twice per turn" },
    SPELL_DAMAGE = { id = "spell_damage", name = "Spell Damage", description = "Increases spell damage" },
    POISONOUS = { id = "poisonous", name = "Poisonous", description = "Destroys any creature damaged by this" }
}

-- Ability triggers
M.ABILITY_TRIGGERS = {
    BATTLECRY = "battlecry",        -- When played from hand
    DEATHRATTLE = "deathrattle",    -- When destroyed
    START_OF_TURN = "start_of_turn", -- At the start of turn
    END_OF_TURN = "end_of_turn",     -- At the end of turn
    ON_ATTACK = "on_attack",         -- When attacking
    ON_DAMAGE = "on_damage",         -- When taking damage
    PASSIVE = "passive"              -- Always active
}

-- Effect types
M.EFFECT_TYPES = {
    DAMAGE = "damage",
    HEAL = "heal",
    DRAW_CARD = "draw_card",
    GAIN_MANA = "gain_mana",
    SUMMON_CREATURE = "summon_creature",
    DESTROY = "destroy",
    SILENCE = "silence",
    BUFF_ATTACK = "buff_attack",
    BUFF_HEALTH = "buff_health",
    GIVE_KEYWORD = "give_keyword"
}

-- Target types
M.TARGET_TYPES = {
    NONE = "none",
    SELF = "self",
    ENEMY_HERO = "enemy_hero",
    FRIENDLY_HERO = "friendly_hero",
    ANY_CREATURE = "any_creature",
    FRIENDLY_CREATURE = "friendly_creature",
    ENEMY_CREATURE = "enemy_creature",
    ALL_CREATURES = "all_creatures",
    RANDOM_ENEMY = "random_enemy"
}

-- Create a new card
function M.create(data)
    local card = {
        id = data.id or "",
        name = data.name or "",
        cost = data.cost or 0,
        type = data.type or M.CARD_TYPES.CREATURE,
        rarity = data.rarity or M.RARITIES.COMMON,
        description = data.description or "",
        image_url = data.image_url,
        
        -- Combat stats (for creatures and weapons)
        attack = data.attack,
        health = data.health,
        durability = data.durability, -- For weapons
        
        -- Card abilities and effects
        abilities = data.abilities or {},
        keywords = data.keywords or {},
        
        -- Card set information
        set_id = data.set_id or "core",
        collectible = data.collectible ~= false
    }
    
    return card
end

-- Check if card is a creature
function M.is_creature(card)
    return card.type == M.CARD_TYPES.CREATURE
end

-- Check if card is a spell
function M.is_spell(card)
    return card.type == M.CARD_TYPES.SPELL
end

-- Check if card is a weapon
function M.is_weapon(card)
    return card.type == M.CARD_TYPES.WEAPON
end

-- Get total stats value for creatures (attack + health)
function M.get_total_stats(card)
    return (card.attack or 0) + (card.health or 0)
end

-- Validate card data
function M.validate(card)
    if not card.name or card.name == "" then
        return false, "Card name cannot be empty"
    end
    
    if card.cost < 0 then
        return false, "Card cost cannot be negative"
    end
    
    if card.type == M.CARD_TYPES.CREATURE then
        if not card.attack or not card.health then
            return false, "Creature cards must have attack and health"
        end
        if card.attack < 0 or card.health <= 0 then
            return false, "Creature stats must be valid (attack >= 0, health > 0)"
        end
    elseif card.type == M.CARD_TYPES.SPELL then
        if card.attack or card.health or card.durability then
            return false, "Spell cards cannot have combat stats"
        end
    elseif card.type == M.CARD_TYPES.WEAPON then
        if not card.attack or not card.durability then
            return false, "Weapon cards must have attack and durability"
        end
        if card.attack <= 0 or card.durability <= 0 then
            return false, "Weapon stats must be positive"
        end
        if card.health then
            return false, "Weapon cards cannot have health"
        end
    end
    
    return true
end

-- Create a card ability
function M.create_ability(data)
    return {
        id = data.id or "",
        name = data.name or "",
        description = data.description or "",
        trigger = data.trigger or M.ABILITY_TRIGGERS.PASSIVE,
        effects = data.effects or {}
    }
end

-- Create a card effect
function M.create_effect(data)
    return {
        type = data.type or M.EFFECT_TYPES.DAMAGE,
        value = data.value or 0,
        target = data.target or M.TARGET_TYPES.NONE,
        condition = data.condition
    }
end

-- Check if card has a specific keyword
function M.has_keyword(card, keyword)
    for _, card_keyword in ipairs(card.keywords) do
        if card_keyword == keyword then
            return true
        end
    end
    return false
end

-- Get card's mana cost with any modifiers
function M.get_effective_cost(card, modifiers)
    local cost = card.cost
    
    if modifiers then
        cost = cost + (modifiers.cost_modifier or 0)
        if modifiers.cost_multiplier then
            cost = math.floor(cost * modifiers.cost_multiplier)
        end
    end
    
    return math.max(0, cost) -- Cost cannot go below 0
end

-- Create a deep copy of a card
function M.copy(card)
    local copy = {}
    
    for key, value in pairs(card) do
        if type(value) == "table" then
            copy[key] = {}
            for k, v in pairs(value) do
                copy[key][k] = v
            end
        else
            copy[key] = value
        end
    end
    
    return copy
end

-- Convert card to a string representation for debugging
function M.to_string(card)
    local stats = ""
    if M.is_creature(card) then
        stats = string.format(" [%d/%d]", card.attack, card.health)
    elseif M.is_weapon(card) then
        stats = string.format(" [%d/%d]", card.attack, card.durability)
    end
    
    return string.format("%s (%d)%s - %s", card.name, card.cost, stats, card.type)
end

return M