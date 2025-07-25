-- Card Database Module
-- Manages the database of all cards in SpireSmiths TCG
-- Loads card data from JSON files and provides card lookup functions

local card_module = require "scripts.entities.card"
local logger = require "scripts.utils.logger"

local M = {}

-- Card database storage
local cards_by_id = {}
local cards_by_set = {}
local cards_by_type = {}
local cards_by_rarity = {}
local all_cards = {}

-- Set definitions
local CARD_SETS = {
    CORE = {
        id = "core",
        name = "Core Set",
        description = "The fundamental cards of SpireSmiths",
        release_date = "2025-07-25"
    },
    BASIC = {
        id = "basic",
        name = "Basic Set",
        description = "Starting cards for new players",
        release_date = "2025-07-25"
    }
}

-- Load card database
function M.load()
    logger.info("Loading card database...")
    
    -- Clear existing data
    clear_database()
    
    -- Load core cards
    load_core_cards()
    
    -- Load basic cards
    load_basic_cards()
    
    -- Build indices
    build_indices()
    
    logger.info(string.format("Card database loaded: %d cards total", #all_cards))
end

-- Clear the database
function clear_database()
    cards_by_id = {}
    cards_by_set = {}
    cards_by_type = {}
    cards_by_rarity = {}
    all_cards = {}
end

-- Load core set cards
function load_core_cards()
    local core_cards = {
        -- Creatures
        {
            id = "fire_elemental",
            name = "Fire Elemental",
            cost = 3,
            type = card_module.CARD_TYPES.CREATURE,
            rarity = card_module.RARITIES.COMMON,
            description = "A blazing creature from the elemental plane of fire.",
            attack = 3,
            health = 2,
            keywords = {},
            set_id = "core"
        },
        {
            id = "water_spirit",
            name = "Water Spirit",
            cost = 2,
            type = card_module.CARD_TYPES.CREATURE,
            rarity = card_module.RARITIES.COMMON,
            description = "A flowing spirit that heals allies.",
            attack = 1,
            health = 3,
            keywords = {},
            set_id = "core"
        },
        {
            id = "earth_guardian",
            name = "Earth Guardian",
            cost = 4,
            type = card_module.CARD_TYPES.CREATURE,
            rarity = card_module.RARITIES.RARE,
            description = "A stalwart defender of the natural world.",
            attack = 2,
            health = 6,
            keywords = { "taunt" },
            set_id = "core"
        },
        {
            id = "air_djinn",
            name = "Air Djinn",
            cost = 5,
            type = card_module.CARD_TYPES.CREATURE,
            rarity = card_module.RARITIES.EPIC,
            description = "An ancient being of pure wind and storm.",
            attack = 4,
            health = 4,
            keywords = { "charge", "windfury" },
            set_id = "core"
        },
        {
            id = "arcane_dragon",
            name = "Arcane Dragon",
            cost = 8,
            type = card_module.CARD_TYPES.CREATURE,
            rarity = card_module.RARITIES.LEGENDARY,
            description = "The most powerful magical creature in existence.",
            attack = 8,
            health = 8,
            keywords = { "spell_damage" },
            set_id = "core"
        },
        
        -- Spells
        {
            id = "lightning_bolt",
            name = "Lightning Bolt",
            cost = 1,
            type = card_module.CARD_TYPES.SPELL,
            rarity = card_module.RARITIES.COMMON,
            description = "Deal 3 damage to any target.",
            set_id = "core"
        },
        {
            id = "healing_light",
            name = "Healing Light",
            cost = 1,
            type = card_module.CARD_TYPES.SPELL,
            rarity = card_module.RARITIES.COMMON,
            description = "Restore 5 health to any character.",
            set_id = "core"
        },
        {
            id = "fireball",
            name = "Fireball",
            cost = 4,
            type = card_module.CARD_TYPES.SPELL,
            rarity = card_module.RARITIES.RARE,
            description = "Deal 6 damage to any target.",
            set_id = "core"
        },
        {
            id = "meteor",
            name = "Meteor",
            cost = 7,
            type = card_module.CARD_TYPES.SPELL,
            rarity = card_module.RARITIES.EPIC,
            description = "Deal 10 damage to all enemies.",
            set_id = "core"
        },
        
        -- Weapons
        {
            id = "iron_sword",
            name = "Iron Sword",
            cost = 3,
            type = card_module.CARD_TYPES.WEAPON,
            rarity = card_module.RARITIES.COMMON,
            description = "A sturdy blade forged from iron.",
            attack = 3,
            durability = 2,
            set_id = "core"
        },
        {
            id = "flame_sword",
            name = "Flame Sword",
            cost = 5,
            type = card_module.CARD_TYPES.WEAPON,
            rarity = card_module.RARITIES.RARE,
            description = "A blade wreathed in eternal flames.",
            attack = 4,
            durability = 3,
            keywords = { "lifesteal" },
            set_id = "core"
        }
    }
    
    for _, card_data in ipairs(core_cards) do
        local card = card_module.create(card_data)
        add_card_to_database(card)
    end
    
    logger.info("Core cards loaded: " .. #core_cards)
end

-- Load basic set cards (starter cards)
function load_basic_cards()
    local basic_cards = {
        -- Basic creatures for starter decks
        {
            id = "novice_warrior",
            name = "Novice Warrior",
            cost = 1,
            type = card_module.CARD_TYPES.CREATURE,
            rarity = card_module.RARITIES.COMMON,
            description = "A young warrior beginning their journey.",
            attack = 1,
            health = 1,
            keywords = {},
            set_id = "basic"
        },
        {
            id = "apprentice_mage",
            name = "Apprentice Mage",
            cost = 2,
            type = card_module.CARD_TYPES.CREATURE,
            rarity = card_module.RARITIES.COMMON,
            description = "A student of the magical arts.",
            attack = 1,
            health = 2,
            keywords = { "spell_damage" },
            set_id = "basic"
        },
        {
            id = "village_guard",
            name = "Village Guard",
            cost = 2,
            type = card_module.CARD_TYPES.CREATURE,
            rarity = card_module.RARITIES.COMMON,
            description = "A brave defender of the innocent.",
            attack = 1,
            health = 4,
            keywords = { "taunt" },
            set_id = "basic"
        },
        {
            id = "swift_scout",
            name = "Swift Scout",
            cost = 3,
            type = card_module.CARD_TYPES.CREATURE,
            rarity = card_module.RARITIES.COMMON,
            description = "Quick and agile, striking without warning.",
            attack = 3,
            health = 1,
            keywords = { "charge" },
            set_id = "basic"
        },
        
        -- Basic spells
        {
            id = "magic_missile",
            name = "Magic Missile",
            cost = 0,
            type = card_module.CARD_TYPES.SPELL,
            rarity = card_module.RARITIES.COMMON,
            description = "Deal 1 damage to any target.",
            set_id = "basic"
        },
        {
            id = "minor_healing",
            name = "Minor Healing",
            cost = 0,
            type = card_module.CARD_TYPES.SPELL,
            rarity = card_module.RARITIES.COMMON,
            description = "Restore 2 health to any character.",
            set_id = "basic"
        }
    }
    
    for _, card_data in ipairs(basic_cards) do
        local card = card_module.create(card_data)
        add_card_to_database(card)
    end
    
    logger.info("Basic cards loaded: " .. #basic_cards)
end

-- Add a card to the database
function add_card_to_database(card)
    -- Validate card before adding
    local valid, error = card_module.validate(card)
    if not valid then
        logger.error("Invalid card: " .. card.name .. " - " .. error)
        return false
    end
    
    -- Add to main collections
    cards_by_id[card.id] = card
    table.insert(all_cards, card)
    
    return true
end

-- Build database indices for fast lookups
function build_indices()
    -- Clear existing indices
    cards_by_set = {}
    cards_by_type = {}
    cards_by_rarity = {}
    
    -- Build indices
    for _, card in ipairs(all_cards) do
        -- Index by set
        if not cards_by_set[card.set_id] then
            cards_by_set[card.set_id] = {}
        end
        table.insert(cards_by_set[card.set_id], card)
        
        -- Index by type
        if not cards_by_type[card.type] then
            cards_by_type[card.type] = {}
        end
        table.insert(cards_by_type[card.type], card)
        
        -- Index by rarity
        local rarity_id = card.rarity.id
        if not cards_by_rarity[rarity_id] then
            cards_by_rarity[rarity_id] = {}
        end
        table.insert(cards_by_rarity[rarity_id], card)
    end
    
    logger.debug("Database indices built")
end

-- Get a card by ID
function M.get_card(card_id)
    return cards_by_id[card_id]
end

-- Get all cards
function M.get_all_cards()
    return all_cards
end

-- Get cards by set
function M.get_cards_by_set(set_id)
    return cards_by_set[set_id] or {}
end

-- Get cards by type
function M.get_cards_by_type(card_type)
    return cards_by_type[card_type] or {}
end

-- Get cards by rarity
function M.get_cards_by_rarity(rarity)
    local rarity_id = type(rarity) == "table" and rarity.id or rarity
    return cards_by_rarity[rarity_id] or {}
end

-- Search cards by name
function M.search_cards(query)
    local results = {}
    local query_lower = string.lower(query)
    
    for _, card in ipairs(all_cards) do
        if string.find(string.lower(card.name), query_lower) then
            table.insert(results, card)
        end
    end
    
    return results
end

-- Filter cards by criteria
function M.filter_cards(criteria)
    local results = {}
    
    for _, card in ipairs(all_cards) do
        local matches = true
        
        -- Check cost range
        if criteria.min_cost and card.cost < criteria.min_cost then
            matches = false
        end
        if criteria.max_cost and card.cost > criteria.max_cost then
            matches = false
        end
        
        -- Check type
        if criteria.type and card.type ~= criteria.type then
            matches = false
        end
        
        -- Check rarity
        if criteria.rarity then
            local rarity_id = type(criteria.rarity) == "table" and criteria.rarity.id or criteria.rarity
            if card.rarity.id ~= rarity_id then
                matches = false
            end
        end
        
        -- Check set
        if criteria.set_id and card.set_id ~= criteria.set_id then
            matches = false
        end
        
        -- Check keywords
        if criteria.keywords then
            for _, required_keyword in ipairs(criteria.keywords) do
                if not card_module.has_keyword(card, required_keyword) then
                    matches = false
                    break
                end
            end
        end
        
        -- Check attack/health ranges (for creatures)
        if card_module.is_creature(card) then
            if criteria.min_attack and card.attack < criteria.min_attack then
                matches = false
            end
            if criteria.max_attack and card.attack > criteria.max_attack then
                matches = false
            end
            if criteria.min_health and card.health < criteria.min_health then
                matches = false
            end
            if criteria.max_health and card.health > criteria.max_health then
                matches = false
            end
        end
        
        if matches then
            table.insert(results, card)
        end
    end
    
    return results
end

-- Get random cards
function M.get_random_cards(count, criteria)
    local pool = criteria and M.filter_cards(criteria) or all_cards
    local results = {}
    
    if #pool == 0 then
        return results
    end
    
    count = math.min(count, #pool)
    local used_indices = {}
    
    for i = 1, count do
        local index
        repeat
            index = math.random(#pool)
        until not used_indices[index]
        
        used_indices[index] = true
        table.insert(results, pool[index])
    end
    
    return results
end

-- Get card statistics
function M.get_statistics()
    local stats = {
        total_cards = #all_cards,
        by_type = {},
        by_rarity = {},
        by_set = {},
        average_cost = 0
    }
    
    -- Calculate type distribution
    for card_type, cards in pairs(cards_by_type) do
        stats.by_type[card_type] = #cards
    end
    
    -- Calculate rarity distribution
    for rarity, cards in pairs(cards_by_rarity) do
        stats.by_rarity[rarity] = #cards
    end
    
    -- Calculate set distribution
    for set_id, cards in pairs(cards_by_set) do
        stats.by_set[set_id] = #cards
    end
    
    -- Calculate average cost
    local total_cost = 0
    for _, card in ipairs(all_cards) do
        total_cost = total_cost + card.cost
    end
    stats.average_cost = total_cost / #all_cards
    
    return stats
end

-- Create a starter deck
function M.create_starter_deck()
    local deck_cards = {}
    
    -- Get basic cards for starter deck
    local basic_cards = M.get_cards_by_set("basic")
    local core_commons = M.filter_cards({
        set_id = "core",
        rarity = card_module.RARITIES.COMMON
    })
    
    -- Add basic cards (multiple copies)
    for _, card in ipairs(basic_cards) do
        local count = card_module.is_creature(card) and 2 or 1
        for i = 1, count do
            table.insert(deck_cards, card)
        end
    end
    
    -- Fill remaining slots with core commons
    local remaining_slots = 30 - #deck_cards
    local additional_cards = M.get_random_cards(remaining_slots, {
        set_id = "core",
        rarity = card_module.RARITIES.COMMON
    })
    
    for _, card in ipairs(additional_cards) do
        table.insert(deck_cards, card)
    end
    
    return deck_cards
end

-- Get card set information
function M.get_sets()
    return CARD_SETS
end

-- Get set information
function M.get_set_info(set_id)
    return CARD_SETS[string.upper(set_id)]
end

return M