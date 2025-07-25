-- Creature Entity Module
-- Represents a creature on the board in SpireSmiths TCG
-- Handles creature states, combat, and abilities

local card_module = require "scripts.entities.card"
local M = {}

-- Creature states
M.STATES = {
    SUMMONED = "summoned",      -- Just played, cannot attack yet
    READY = "ready",            -- Can attack
    ATTACKED = "attacked",      -- Has attacked this turn
    EXHAUSTED = "exhausted",    -- Cannot attack (used ability, etc.)
    SILENCED = "silenced",      -- All abilities removed
    FROZEN = "frozen",          -- Cannot attack next turn
    SLEEPING = "sleeping"       -- Cannot attack (summoning sickness)
}

-- Create a creature from a card
function M.create_from_card(card, instance_id)
    if not card_module.is_creature(card) then
        return nil, "Card is not a creature type"
    end
    
    local creature = {
        card_id = card.id,
        instance_id = instance_id or generate_instance_id(),
        name = card.name,
        
        -- Base stats
        base_attack = card.attack,
        base_health = card.health,
        
        -- Current stats (can be modified by effects)
        attack = card.attack,
        health = card.health,
        max_health = card.health,
        
        -- State flags
        state = M.STATES.SUMMONED,
        can_attack = card_module.has_keyword(card, "charge"),
        has_attacked = false,
        summoned_this_turn = true,
        
        -- Keywords and abilities
        keywords = {},
        abilities = {},
        temporary_effects = {},
        
        -- Combat history
        damage_taken_this_turn = 0,
        damage_dealt_this_turn = 0,
        times_attacked_this_turn = 0
    }
    
    -- Copy keywords from card
    for _, keyword in ipairs(card.keywords) do
        table.insert(creature.keywords, keyword)
    end
    
    -- Copy abilities from card
    for _, ability in ipairs(card.abilities) do
        table.insert(creature.abilities, ability)
    end
    
    return creature
end

-- Generate a unique instance ID
function generate_instance_id()
    return "creature_" .. tostring(os.time()) .. "_" .. tostring(math.random(1000, 9999))
end

-- Check if creature is alive
function M.is_alive(creature)
    return creature.health > 0
end

-- Check if creature is dead
function M.is_dead(creature)
    return creature.health <= 0
end

-- Check if creature is damaged
function M.is_damaged(creature)
    return creature.health < creature.max_health
end

-- Check if creature can attack
function M.can_attack(creature)
    if not M.is_alive(creature) then
        return false
    end
    
    if creature.state == M.STATES.ATTACKED or creature.state == M.STATES.EXHAUSTED then
        return false
    end
    
    if not creature.can_attack then
        return false
    end
    
    -- Check for Windfury (can attack twice)
    if M.has_keyword(creature, "windfury") then
        return creature.times_attacked_this_turn < 2
    end
    
    return not creature.has_attacked
end

-- Check if creature has a specific keyword
function M.has_keyword(creature, keyword)
    for _, creature_keyword in ipairs(creature.keywords) do
        if creature_keyword == keyword then
            return true
        end
    end
    return false
end

-- Add keyword to creature
function M.add_keyword(creature, keyword)
    if not M.has_keyword(creature, keyword) then
        table.insert(creature.keywords, keyword)
    end
end

-- Remove keyword from creature
function M.remove_keyword(creature, keyword)
    for i, creature_keyword in ipairs(creature.keywords) do
        if creature_keyword == keyword then
            table.remove(creature.keywords, i)
            break
        end
    end
end

-- Deal damage to creature
function M.take_damage(creature, amount, source, is_spell)
    source = source or "unknown"
    is_spell = is_spell or false
    
    -- Check for Divine Shield
    if M.has_keyword(creature, "divine_shield") and amount > 0 then
        M.remove_keyword(creature, "divine_shield")
        return 0 -- Damage absorbed by Divine Shield
    end
    
    local actual_damage = math.min(amount, creature.health)
    creature.health = creature.health - actual_damage
    creature.damage_taken_this_turn = creature.damage_taken_this_turn + actual_damage
    
    return actual_damage
end

-- Heal creature
function M.heal(creature, amount, source)
    source = source or "unknown"
    local actual_healing = math.min(amount, creature.max_health - creature.health)
    
    creature.health = creature.health + actual_healing
    
    return actual_healing
end

-- Buff creature's attack
function M.buff_attack(creature, amount, permanent)
    permanent = permanent or false
    
    creature.attack = creature.attack + amount
    
    if permanent then
        creature.base_attack = creature.base_attack + amount
    else
        -- Add temporary effect
        table.insert(creature.temporary_effects, {
            type = "attack_buff",
            value = amount,
            duration = -1 -- Permanent until end of game
        })
    end
end

-- Buff creature's health
function M.buff_health(creature, amount, permanent)
    permanent = permanent or false
    
    creature.health = creature.health + amount
    creature.max_health = creature.max_health + amount
    
    if permanent then
        creature.base_health = creature.base_health + amount
    else
        -- Add temporary effect
        table.insert(creature.temporary_effects, {
            type = "health_buff",
            value = amount,
            duration = -1
        })
    end
end

-- Set creature attack value
function M.set_attack(creature, value)
    creature.attack = math.max(0, value)
end

-- Set creature health value
function M.set_health(creature, value)
    creature.health = math.max(0, value)
    creature.max_health = math.max(creature.max_health, value)
end

-- Attack with this creature
function M.attack(creature, target)
    if not M.can_attack(creature) then
        return false, "Creature cannot attack"
    end
    
    creature.has_attacked = true
    creature.times_attacked_this_turn = creature.times_attacked_this_turn + 1
    creature.state = M.STATES.ATTACKED
    
    -- Check for Windfury
    if M.has_keyword(creature, "windfury") and creature.times_attacked_this_turn < 2 then
        creature.has_attacked = false
        creature.state = M.STATES.READY
    end
    
    return true
end

-- Silence creature (remove all abilities and keywords)
function M.silence(creature)
    creature.keywords = {}
    creature.abilities = {}
    creature.temporary_effects = {}
    creature.state = M.STATES.SILENCED
    
    -- Reset stats to base values
    creature.attack = creature.base_attack
    creature.max_health = creature.base_health
    creature.health = math.min(creature.health, creature.max_health)
end

-- Freeze creature
function M.freeze(creature)
    creature.state = M.STATES.FROZEN
    creature.can_attack = false
end

-- Unfreeze creature
function M.unfreeze(creature)
    if creature.state == M.STATES.FROZEN then
        creature.state = M.STATES.READY
        creature.can_attack = true
    end
end

-- Start of turn for creature
function M.start_turn(creature)
    -- Remove summoning sickness
    if creature.summoned_this_turn then
        creature.summoned_this_turn = false
        if not M.has_keyword(creature, "charge") then
            creature.can_attack = true
        end
    end
    
    -- Reset attack flags
    creature.has_attacked = false
    creature.times_attacked_this_turn = 0
    creature.damage_taken_this_turn = 0
    creature.damage_dealt_this_turn = 0
    
    -- Unfreeze if frozen
    if creature.state == M.STATES.FROZEN then
        M.unfreeze(creature)
    elseif creature.state == M.STATES.ATTACKED then
        creature.state = M.STATES.READY
    end
    
    -- Process temporary effects
    process_temporary_effects(creature)
end

-- Process temporary effects
function process_temporary_effects(creature)
    local i = 1
    while i <= #creature.temporary_effects do
        local effect = creature.temporary_effects[i]
        
        if effect.duration > 0 then
            effect.duration = effect.duration - 1
        end
        
        if effect.duration == 0 then
            -- Remove expired effect
            table.remove(creature.temporary_effects, i)
        else
            i = i + 1
        end
    end
end

-- Get creature's effective attack (with all modifiers)
function M.get_effective_attack(creature)
    return math.max(0, creature.attack)
end

-- Get creature's effective health
function M.get_effective_health(creature)
    return math.max(0, creature.health)
end

-- Check if creature has Taunt
function M.has_taunt(creature)
    return M.has_keyword(creature, "taunt")
end

-- Check if creature has Stealth
function M.has_stealth(creature)
    return M.has_keyword(creature, "stealth")
end

-- Break stealth (when creature attacks)
function M.break_stealth(creature)
    if M.has_stealth(creature) then
        M.remove_keyword(creature, "stealth")
    end
end

-- Get creature display information
function M.get_display_info(creature)
    return {
        name = creature.name,
        attack = creature.attack,
        health = creature.health,
        max_health = creature.max_health,
        keywords = creature.keywords,
        can_attack = M.can_attack(creature),
        is_damaged = M.is_damaged(creature),
        state = creature.state
    }
end

-- Create a copy of creature (for AI simulation)
function M.copy(creature)
    local copy = {}
    
    -- Copy simple values
    for key, value in pairs(creature) do
        if type(value) ~= "table" then
            copy[key] = value
        end
    end
    
    -- Deep copy tables
    copy.keywords = {}
    for i, keyword in ipairs(creature.keywords) do
        copy.keywords[i] = keyword
    end
    
    copy.abilities = {}
    for i, ability in ipairs(creature.abilities) do
        copy.abilities[i] = ability
    end
    
    copy.temporary_effects = {}
    for i, effect in ipairs(creature.temporary_effects) do
        copy.temporary_effects[i] = {}
        for k, v in pairs(effect) do
            copy.temporary_effects[i][k] = v
        end
    end
    
    return copy
end

-- Convert creature to string for debugging
function M.to_string(creature)
    local state_info = ""
    if creature.state ~= M.STATES.READY then
        state_info = " (" .. creature.state .. ")"
    end
    
    local keywords_info = ""
    if #creature.keywords > 0 then
        keywords_info = " [" .. table.concat(creature.keywords, ", ") .. "]"
    end
    
    return string.format("%s [%d/%d]%s%s", 
        creature.name, 
        creature.attack, 
        creature.health, 
        state_info, 
        keywords_info
    )
end

return M