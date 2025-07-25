-- Deck Entity Module
-- Represents a deck of cards in SpireSmiths TCG
-- Handles deck validation, shuffling, and management

local card_module = require "scripts.entities.card"
local M = {}

-- Deck size constants
M.DECK_SIZE = 30
M.MAX_CARD_COPIES = 2
M.MAX_LEGENDARY_COPIES = 1

-- Hero classes (for future expansion)
M.HERO_CLASSES = {
    NEUTRAL = "neutral",
    WARRIOR = "warrior",
    MAGE = "mage",
    PRIEST = "priest",
    ROGUE = "rogue",
    HUNTER = "hunter",
    WARLOCK = "warlock",
    SHAMAN = "shaman",
    PALADIN = "paladin",
    DRUID = "druid"
}

-- Create a new deck
function M.create(data)
    local deck = {
        id = data.id or generate_deck_id(),
        name = data.name or "New Deck",
        cards = data.cards or {},
        hero_class = data.hero_class or M.HERO_CLASSES.NEUTRAL,
        is_valid = false,
        created_at = os.time(),
        updated_at = os.time()
    }
    
    -- Validate the deck
    deck.is_valid = M.validate(deck).is_valid
    
    return deck
end

-- Generate a unique deck ID
function generate_deck_id()
    return "deck_" .. tostring(os.time()) .. "_" .. tostring(math.random(1000, 9999))
end

-- Create a deck card entry
function M.create_deck_card(card, count)
    count = count or 1
    
    if count < 1 then
        return nil, "Card count must be positive"
    end
    
    local max_copies = M.MAX_CARD_COPIES
    if card.rarity == card_module.RARITIES.LEGENDARY then
        max_copies = M.MAX_LEGENDARY_COPIES
    end
    
    if count > max_copies then
        return nil, string.format("Too many copies of %s (max %d)", card.name, max_copies)
    end
    
    return {
        card = card,
        count = count
    }
end

-- Get total number of cards in deck
function M.get_total_cards(deck)
    local total = 0
    for _, deck_card in ipairs(deck.cards) do
        total = total + deck_card.count
    end
    return total
end

-- Get total mana cost of all cards
function M.get_total_mana_cost(deck)
    local total = 0
    for _, deck_card in ipairs(deck.cards) do
        total = total + (deck_card.card.cost * deck_card.count)
    end
    return total
end

-- Get average mana cost
function M.get_average_mana_cost(deck)
    local total_cards = M.get_total_cards(deck)
    if total_cards == 0 then
        return 0
    end
    return M.get_total_mana_cost(deck) / total_cards
end

-- Validate deck according to game rules
function M.validate(deck)
    local errors = {}
    local warnings = {}
    
    -- Check deck size
    local total_cards = M.get_total_cards(deck)
    if total_cards ~= M.DECK_SIZE then
        table.insert(errors, string.format("Deck must contain exactly %d cards (currently has %d)", M.DECK_SIZE, total_cards))
    end
    
    -- Check card limits and duplicates
    local card_ids = {}
    for _, deck_card in ipairs(deck.cards) do
        local card = deck_card.card
        local count = deck_card.count
        
        -- Check for duplicate entries
        if card_ids[card.id] then
            table.insert(errors, string.format("Duplicate entries for card: %s", card.name))
        else
            card_ids[card.id] = true
        end
        
        -- Check card limits
        local max_copies = M.MAX_CARD_COPIES
        if card.rarity == card_module.RARITIES.LEGENDARY then
            max_copies = M.MAX_LEGENDARY_COPIES
        end
        
        if count > max_copies then
            table.insert(errors, string.format("Too many copies of %s (%d/%d)", card.name, count, max_copies))
        end
        
        -- Validate individual cards
        local card_valid, card_error = card_module.validate(card)
        if not card_valid then
            table.insert(errors, string.format("Invalid card %s: %s", card.name, card_error))
        end
    end
    
    -- Check mana curve (warning if heavily skewed)
    local curve = M.get_mana_curve(deck)
    local high_cost_cards = (curve[8] or 0) + (curve[9] or 0) + (curve[10] or 0) + (curve[11] or 0)
    if high_cost_cards > total_cards * 0.3 then
        table.insert(warnings, "Deck has many high-cost cards - consider adding more low-cost cards")
    end
    
    local low_cost_cards = (curve[1] or 0) + (curve[2] or 0)
    if low_cost_cards < total_cards * 0.15 then
        table.insert(warnings, "Deck has few low-cost cards - consider adding early game options")
    end
    
    return {
        is_valid = #errors == 0,
        errors = errors,
        warnings = warnings
    }
end

-- Get cards grouped by mana cost
function M.get_cards_by_mana_cost(deck)
    local by_cost = {}
    
    for _, deck_card in ipairs(deck.cards) do
        local cost = deck_card.card.cost
        if not by_cost[cost] then
            by_cost[cost] = {}
        end
        table.insert(by_cost[cost], deck_card)
    end
    
    return by_cost
end

-- Get cards grouped by type
function M.get_cards_by_type(deck)
    local by_type = {}
    
    for _, deck_card in ipairs(deck.cards) do
        local card_type = deck_card.card.type
        if not by_type[card_type] then
            by_type[card_type] = {}
        end
        table.insert(by_type[card_type], deck_card)
    end
    
    return by_type
end

-- Get mana curve (array of card counts by mana cost)
function M.get_mana_curve(deck)
    local curve = {}
    
    for i = 0, 10 do
        curve[i + 1] = 0
    end
    
    for _, deck_card in ipairs(deck.cards) do
        local cost = math.min(deck_card.card.cost, 10) -- 10+ mana costs grouped together
        curve[cost + 1] = curve[cost + 1] + deck_card.count
    end
    
    return curve
end

-- Shuffle deck and return a list of individual cards
function M.shuffle(deck)
    local all_cards = {}
    
    -- Expand deck cards into individual cards
    for _, deck_card in ipairs(deck.cards) do
        for i = 1, deck_card.count do
            table.insert(all_cards, deck_card.card)
        end
    end
    
    -- Fisher-Yates shuffle
    local n = #all_cards
    for i = n, 2, -1 do
        local j = math.random(i)
        all_cards[i], all_cards[j] = all_cards[j], all_cards[i]
    end
    
    return all_cards
end

-- Add a card to the deck
function M.add_card(deck, card, count)
    count = count or 1
    
    -- Check if card already exists in deck
    for _, deck_card in ipairs(deck.cards) do
        if deck_card.card.id == card.id then
            -- Update existing entry
            local new_count = deck_card.count + count
            local max_copies = M.MAX_CARD_COPIES
            if card.rarity == card_module.RARITIES.LEGENDARY then
                max_copies = M.MAX_LEGENDARY_COPIES
            end
            
            if new_count > max_copies then
                return false, string.format("Cannot add %d more copies of %s (would exceed limit of %d)", count, card.name, max_copies)
            end
            
            deck_card.count = new_count
            deck.updated_at = os.time()
            deck.is_valid = M.validate(deck).is_valid
            return true
        end
    end
    
    -- Add new card entry
    local deck_card, error = M.create_deck_card(card, count)
    if not deck_card then
        return false, error
    end
    
    table.insert(deck.cards, deck_card)
    deck.updated_at = os.time()
    deck.is_valid = M.validate(deck).is_valid
    return true
end

-- Remove a card from the deck
function M.remove_card(deck, card_id, count)
    count = count or 1
    
    for i, deck_card in ipairs(deck.cards) do
        if deck_card.card.id == card_id then
            if deck_card.count <= count then
                -- Remove entire entry
                table.remove(deck.cards, i)
            else
                -- Reduce count
                deck_card.count = deck_card.count - count
            end
            
            deck.updated_at = os.time()
            deck.is_valid = M.validate(deck).is_valid
            return true
        end
    end
    
    return false, "Card not found in deck"
end

-- Find a card in the deck
function M.find_card(deck, card_id)
    for _, deck_card in ipairs(deck.cards) do
        if deck_card.card.id == card_id then
            return deck_card
        end
    end
    return nil
end

-- Get deck statistics
function M.get_statistics(deck)
    local total_cards = M.get_total_cards(deck)
    local by_type = M.get_cards_by_type(deck)
    
    local creature_count = 0
    local spell_count = 0
    local weapon_count = 0
    
    if by_type[card_module.CARD_TYPES.CREATURE] then
        for _, deck_card in ipairs(by_type[card_module.CARD_TYPES.CREATURE]) do
            creature_count = creature_count + deck_card.count
        end
    end
    
    if by_type[card_module.CARD_TYPES.SPELL] then
        for _, deck_card in ipairs(by_type[card_module.CARD_TYPES.SPELL]) do
            spell_count = spell_count + deck_card.count
        end
    end
    
    if by_type[card_module.CARD_TYPES.WEAPON] then
        for _, deck_card in ipairs(by_type[card_module.CARD_TYPES.WEAPON]) do
            weapon_count = weapon_count + deck_card.count
        end
    end
    
    return {
        total_cards = total_cards,
        creature_count = creature_count,
        spell_count = spell_count,
        weapon_count = weapon_count,
        average_mana_cost = M.get_average_mana_cost(deck),
        mana_curve = M.get_mana_curve(deck),
        is_valid = deck.is_valid
    }
end

-- Create a copy of the deck
function M.copy(deck)
    local copy = {
        id = deck.id .. "_copy",
        name = deck.name .. " (Copy)",
        cards = {},
        hero_class = deck.hero_class,
        is_valid = deck.is_valid,
        created_at = os.time(),
        updated_at = os.time()
    }
    
    -- Deep copy cards
    for _, deck_card in ipairs(deck.cards) do
        table.insert(copy.cards, {
            card = deck_card.card, -- Cards are immutable, shallow copy is fine
            count = deck_card.count
        })
    end
    
    return copy
end

return M