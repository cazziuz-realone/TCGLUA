-- Player Entity Module
-- Represents a player in the SpireSmiths TCG
-- Handles both human and AI players

local M = {}

-- AI difficulty levels
M.AI_DIFFICULTIES = {
    EASY = { id = "easy", name = "Easy", thinking_time = 0.5 },
    MEDIUM = { id = "medium", name = "Medium", thinking_time = 1.0 },
    HARD = { id = "hard", name = "Hard", thinking_time = 1.5 },
    EXPERT = { id = "expert", name = "Expert", thinking_time = 2.0 }
}

-- Hero classes (for future expansion)
M.HERO_CLASSES = {
    NEUTRAL = { id = "neutral", name = "Neutral" },
    WARRIOR = { id = "warrior", name = "Warrior" },
    MAGE = { id = "mage", name = "Mage" },
    PRIEST = { id = "priest", name = "Priest" },
    ROGUE = { id = "rogue", name = "Rogue" },
    HUNTER = { id = "hunter", name = "Hunter" },
    WARLOCK = { id = "warlock", name = "Warlock" },
    SHAMAN = { id = "shaman", name = "Shaman" },
    PALADIN = { id = "paladin", name = "Paladin" },
    DRUID = { id = "druid", name = "Druid" }
}

-- Create a new player
function M.create(data)
    local player = {
        id = data.id or "",
        name = data.name or "Player",
        is_ai = data.is_ai or false,
        difficulty = data.difficulty or M.AI_DIFFICULTIES.MEDIUM,
        hero_class = data.hero_class or M.HERO_CLASSES.NEUTRAL,
        avatar = data.avatar or "default"
    }
    
    return player
end

-- Check if player is human
function M.is_human(player)
    return not player.is_ai
end

-- Check if player is AI
function M.is_ai(player)
    return player.is_ai
end

-- Create a player state for a game
function M.create_state(player_id, deck)
    local state = {
        player_id = player_id,
        health = 30,
        max_health = 30,
        mana = 0,
        max_mana = 0,
        hand = {},
        deck = deck or {},
        board = {},
        weapon = nil,
        hero_power = nil,
        fatigue_damage = 0,
        
        -- Game state flags
        has_played_card_this_turn = false,
        has_attacked_this_turn = false,
        cards_drawn_this_turn = 0
    }
    
    return state
end

-- Check if player is alive
function M.is_alive(player_state)
    return player_state.health > 0
end

-- Check if player is dead
function M.is_dead(player_state)
    return player_state.health <= 0
end

-- Get hand size
function M.get_hand_size(player_state)
    return #player_state.hand
end

-- Get board size (number of creatures)
function M.get_board_size(player_state)
    return #player_state.board
end

-- Check if hand is full (10 cards max)
function M.is_hand_full(player_state)
    return M.get_hand_size(player_state) >= 10
end

-- Check if board is full (7 creatures max)
function M.is_board_full(player_state)
    return M.get_board_size(player_state) >= 7
end

-- Check if player can play any card from hand
function M.can_play_any_card(player_state)
    for _, card in ipairs(player_state.hand) do
        if card.cost <= player_state.mana then
            return true
        end
    end
    return false
end

-- Get all playable cards from hand
function M.get_playable_cards(player_state)
    local playable = {}
    
    for _, card in ipairs(player_state.hand) do
        if card.cost <= player_state.mana then
            table.insert(playable, card)
        end
    end
    
    return playable
end

-- Add a card to hand
function M.add_to_hand(player_state, card)
    if M.is_hand_full(player_state) then
        return false, "Hand is full"
    end
    
    table.insert(player_state.hand, card)
    return true
end

-- Remove a card from hand by index
function M.remove_from_hand(player_state, index)
    if index < 1 or index > #player_state.hand then
        return nil
    end
    
    return table.remove(player_state.hand, index)
end

-- Remove a card from hand by card ID
function M.remove_card_from_hand(player_state, card_id)
    for i, card in ipairs(player_state.hand) do
        if card.id == card_id then
            return table.remove(player_state.hand, i)
        end
    end
    return nil
end

-- Draw a card from deck
function M.draw_card(player_state)
    if #player_state.deck == 0 then
        -- Fatigue damage
        player_state.fatigue_damage = player_state.fatigue_damage + 1
        M.take_damage(player_state, player_state.fatigue_damage, "fatigue")
        return nil, "fatigue"
    end
    
    if M.is_hand_full(player_state) then
        -- Card is burned (destroyed)
        local burned_card = table.remove(player_state.deck, 1)
        return burned_card, "burned"
    end
    
    local card = table.remove(player_state.deck, 1)
    table.insert(player_state.hand, card)
    player_state.cards_drawn_this_turn = player_state.cards_drawn_this_turn + 1
    
    return card, "drawn"
end

-- Shuffle the deck
function M.shuffle_deck(player_state)
    local deck = player_state.deck
    local n = #deck
    
    for i = n, 2, -1 do
        local j = math.random(i)
        deck[i], deck[j] = deck[j], deck[i]
    end
end

-- Take damage
function M.take_damage(player_state, amount, source)
    source = source or "unknown"
    local actual_damage = math.min(amount, player_state.health)
    
    player_state.health = player_state.health - actual_damage
    
    return actual_damage
end

-- Heal health
function M.heal(player_state, amount, source)
    source = source or "unknown"
    local actual_healing = math.min(amount, player_state.max_health - player_state.health)
    
    player_state.health = player_state.health + actual_healing
    
    return actual_healing
end

-- Gain mana
function M.gain_mana(player_state, amount)
    player_state.mana = math.min(player_state.mana + amount, 10) -- Max 10 mana
end

-- Spend mana
function M.spend_mana(player_state, amount)
    if player_state.mana < amount then
        return false
    end
    
    player_state.mana = player_state.mana - amount
    return true
end

-- Increase max mana (start of turn)
function M.increase_max_mana(player_state)
    if player_state.max_mana < 10 then
        player_state.max_mana = player_state.max_mana + 1
    end
end

-- Refresh mana to maximum
function M.refresh_mana(player_state)
    player_state.mana = player_state.max_mana
end

-- Add creature to board
function M.add_to_board(player_state, creature, position)
    if M.is_board_full(player_state) then
        return false, "Board is full"
    end
    
    position = position or (#player_state.board + 1)
    position = math.max(1, math.min(position, #player_state.board + 1))
    
    table.insert(player_state.board, position, creature)
    return true
end

-- Remove creature from board
function M.remove_from_board(player_state, creature_id)
    for i, creature in ipairs(player_state.board) do
        if creature.instance_id == creature_id then
            return table.remove(player_state.board, i)
        end
    end
    return nil
end

-- Get creature from board by ID
function M.get_creature_from_board(player_state, creature_id)
    for _, creature in ipairs(player_state.board) do
        if creature.instance_id == creature_id then
            return creature
        end
    end
    return nil
end

-- Reset turn-based flags
function M.start_turn(player_state)
    player_state.has_played_card_this_turn = false
    player_state.has_attacked_this_turn = false
    player_state.cards_drawn_this_turn = 0
    
    -- Reset creature attack flags
    for _, creature in ipairs(player_state.board) do
        creature.has_attacked = false
        creature.can_attack = true
    end
end

-- End turn cleanup
function M.end_turn(player_state)
    -- Any end-of-turn effects would go here
end

-- Get player statistics
function M.get_statistics(player_state)
    return {
        health = player_state.health,
        max_health = player_state.max_health,
        mana = player_state.mana,
        max_mana = player_state.max_mana,
        hand_size = M.get_hand_size(player_state),
        board_size = M.get_board_size(player_state),
        deck_size = #player_state.deck,
        fatigue_damage = player_state.fatigue_damage
    }
end

-- Create a copy of player state (for AI simulation)
function M.copy_state(player_state)
    local copy = {}
    
    -- Copy simple values
    for key, value in pairs(player_state) do
        if type(value) ~= "table" then
            copy[key] = value
        end
    end
    
    -- Deep copy tables
    copy.hand = {}
    for i, card in ipairs(player_state.hand) do
        copy.hand[i] = card -- Cards are immutable, so shallow copy is fine
    end
    
    copy.deck = {}
    for i, card in ipairs(player_state.deck) do
        copy.deck[i] = card
    end
    
    copy.board = {}
    for i, creature in ipairs(player_state.board) do
        copy.board[i] = {}
        for k, v in pairs(creature) do
            copy.board[i][k] = v
        end
    end
    
    if player_state.weapon then
        copy.weapon = {}
        for k, v in pairs(player_state.weapon) do
            copy.weapon[k] = v
        end
    end
    
    return copy
end

return M