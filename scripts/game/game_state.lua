-- Game State Module
-- Manages the complete state of a SpireSmiths TCG game
-- Handles game flow, turn management, and state transitions

local player_module = require "scripts.entities.player"
local deck_module = require "scripts.entities.deck"
local logger = require "scripts.utils.logger"

local M = {}

-- Game phases
M.GAME_PHASES = {
    INIT = "init",
    MULLIGAN = "mulligan",
    START_TURN = "start_turn",
    MAIN = "main",
    END_TURN = "end_turn",
    GAME_OVER = "game_over"
}

-- Win conditions
M.WIN_CONDITIONS = {
    OPPONENT_DEFEATED = "opponent_defeated",
    OPPONENT_FATIGUE = "opponent_fatigue",
    SPECIAL_CONDITION = "special_condition",
    CONCEDE = "concede",
    TIMEOUT = "timeout"
}

-- Create a new game instance
function M.create_new_game(config)
    local game_id = generate_game_id()
    
    logger.info("Creating new game: " .. game_id)
    
    -- Create players
    local player1 = player_module.create({
        id = "player1",
        name = config.player_name or "Player",
        is_ai = false
    })
    
    local player2 = player_module.create({
        id = "player2",
        name = "AI Opponent",
        is_ai = true,
        difficulty = player_module.AI_DIFFICULTIES[string.upper(config.ai_difficulty or "MEDIUM")]
    })
    
    -- Create game state
    local game = {
        id = game_id,
        players = { player1, player2 },
        current_state = {
            game_id = game_id,
            turn = 0,
            current_player_index = 1, -- Player 1 goes first
            phase = M.GAME_PHASES.INIT,
            players = {},
            history = {},
            winner_id = nil,
            win_condition = nil
        },
        created_at = os.time(),
        updated_at = os.time()
    }
    
    -- Initialize player states
    initialize_player_states(game, config)
    
    -- Start the game
    start_game(game)
    
    return game
end

-- Generate a unique game ID
function generate_game_id()
    return "game_" .. tostring(os.time()) .. "_" .. tostring(math.random(1000, 9999))
end

-- Initialize player states for the game
function initialize_player_states(game, config)
    for i, player in ipairs(game.players) do
        -- Create appropriate deck for player
        local deck
        if player.is_ai then
            deck = create_ai_deck(player.difficulty)
        else
            deck = config.player_deck or create_starter_deck()
        end
        
        -- Shuffle the deck
        local shuffled_cards = deck_module.shuffle(deck)
        
        -- Create player state
        local player_state = player_module.create_state(player.id, shuffled_cards)
        
        table.insert(game.current_state.players, player_state)
    end
end

-- Start the game
function start_game(game)
    logger.info("Starting game: " .. game.id)
    
    -- Add game start event
    add_game_event(game, {
        type = "game_started",
        player_id = "",
        data = {
            player1_id = game.players[1].id,
            player2_id = game.players[2].id
        }
    })
    
    -- Deal initial hands
    deal_initial_hands(game)
    
    -- Transition to mulligan phase
    transition_to_phase(game, M.GAME_PHASES.MULLIGAN)
end

-- Deal initial hands to players
function deal_initial_hands(game)
    local initial_hand_size = 3 -- Starting hand size
    
    for i, player_state in ipairs(game.current_state.players) do
        for j = 1, initial_hand_size do
            local card, result = player_module.draw_card(player_state)
            if card and result == "drawn" then
                add_game_event(game, {
                    type = "card_drawn",
                    player_id = player_state.player_id,
                    data = { card_id = card.id }
                })
            end
        end
        
        logger.info(string.format("Player %s drew %d cards", player_state.player_id, player_module.get_hand_size(player_state)))
    end
end

-- Transition between game phases
function transition_to_phase(game, new_phase)
    local old_phase = game.current_state.phase
    logger.info(string.format("Game %s: Transitioning from %s to %s", game.id, old_phase, new_phase))
    
    -- Phase cleanup
    cleanup_phase(game, old_phase)
    
    -- Set new phase
    game.current_state.phase = new_phase
    game.updated_at = os.time()
    
    -- Phase initialization
    initialize_phase(game, new_phase)
end

-- Clean up current phase
function cleanup_phase(game, phase)
    if phase == M.GAME_PHASES.MAIN then
        -- End main phase cleanup
    elseif phase == M.GAME_PHASES.END_TURN then
        -- End turn cleanup
        local current_player = get_current_player_state(game)
        player_module.end_turn(current_player)
    end
end

-- Initialize new phase
function initialize_phase(game, phase)
    if phase == M.GAME_PHASES.START_TURN then
        start_turn(game)
    elseif phase == M.GAME_PHASES.MAIN then
        -- Main phase ready for player actions
        logger.info("Main phase started - waiting for player actions")
    elseif phase == M.GAME_PHASES.GAME_OVER then
        end_game(game)
    end
end

-- Start a new turn
function start_turn(game)
    game.current_state.turn = game.current_state.turn + 1
    local current_player = get_current_player_state(game)
    
    logger.info(string.format("Turn %d started for player %s", game.current_state.turn, current_player.player_id))
    
    -- Add turn start event
    add_game_event(game, {
        type = "turn_started",
        player_id = current_player.player_id,
        data = { turn_number = game.current_state.turn }
    })
    
    -- Increase max mana
    player_module.increase_max_mana(current_player)
    
    -- Refresh mana
    player_module.refresh_mana(current_player)
    
    -- Draw a card (except turn 1)
    if game.current_state.turn > 1 then
        local card, result = player_module.draw_card(current_player)
        if card then
            if result == "drawn" then
                add_game_event(game, {
                    type = "card_drawn",
                    player_id = current_player.player_id,
                    data = { card_id = card.id }
                })
            elseif result == "fatigue" then
                add_game_event(game, {
                    type = "fatigue_damage",
                    player_id = current_player.player_id,
                    data = { damage = current_player.fatigue_damage }
                })
            end
        end
    end
    
    -- Start turn for player
    player_module.start_turn(current_player)
    
    -- Check for game over conditions
    if check_game_over(game) then
        return
    end
    
    -- Transition to main phase
    transition_to_phase(game, M.GAME_PHASES.MAIN)
end

-- End the current turn
function M.end_turn(game)
    local current_player = get_current_player_state(game)
    
    logger.info(string.format("Ending turn for player %s", current_player.player_id))
    
    -- Add turn end event
    add_game_event(game, {
        type = "turn_ended",
        player_id = current_player.player_id,
        data = { turn_number = game.current_state.turn }
    })
    
    -- Transition to end turn phase
    transition_to_phase(game, M.GAME_PHASES.END_TURN)
    
    -- Switch to next player
    game.current_state.current_player_index = 3 - game.current_state.current_player_index -- Toggle between 1 and 2
    
    -- Start next turn
    transition_to_phase(game, M.GAME_PHASES.START_TURN)
end

-- Check for game over conditions
function check_game_over(game)
    for i, player_state in ipairs(game.current_state.players) do
        if player_module.is_dead(player_state) then
            -- Player is dead
            local winner_index = 3 - i -- The other player
            local winner_id = game.current_state.players[winner_index].player_id
            
            set_game_winner(game, winner_id, M.WIN_CONDITIONS.OPPONENT_DEFEATED)
            return true
        end
    end
    
    return false
end

-- Set the game winner
function set_game_winner(game, winner_id, win_condition)
    game.current_state.winner_id = winner_id
    game.current_state.win_condition = win_condition
    
    add_game_event(game, {
        type = "game_ended",
        player_id = winner_id,
        data = {
            winner_id = winner_id,
            win_condition = win_condition
        }
    })
    
    transition_to_phase(game, M.GAME_PHASES.GAME_OVER)
    
    logger.info(string.format("Game %s ended. Winner: %s (%s)", game.id, winner_id, win_condition))
end

-- End the game
function end_game(game)
    logger.info("Game ended: " .. game.id)
    
    -- Game cleanup would go here
    -- Save statistics, etc.
end

-- Get current player
function M.get_current_player(game)
    return game.players[game.current_state.current_player_index]
end

-- Get current player state
function get_current_player_state(game)
    return game.current_state.players[game.current_state.current_player_index]
end

-- Get opponent player state
function M.get_opponent_player_state(game)
    local opponent_index = 3 - game.current_state.current_player_index
    return game.current_state.players[opponent_index]
end

-- Check if game is over
function M.is_game_over(game)
    return game.current_state.phase == M.GAME_PHASES.GAME_OVER
end

-- Get game winner
function M.get_winner(game)
    if M.is_game_over(game) and game.current_state.winner_id then
        for _, player in ipairs(game.players) do
            if player.id == game.current_state.winner_id then
                return player
            end
        end
    end
    return nil
end

-- Add a game event to history
function add_game_event(game, event)
    event.timestamp = os.time()
    table.insert(game.current_state.history, event)
end

-- Get recent game events
function M.get_recent_events(game, count)
    count = count or 10
    local history = game.current_state.history
    local start_index = math.max(1, #history - count + 1)
    
    local recent = {}
    for i = start_index, #history do
        table.insert(recent, history[i])
    end
    
    return recent
end

-- Update game state (called each frame)
function M.update(game, dt)
    if M.is_game_over(game) then
        return
    end
    
    -- Update timers, animations, etc.
    -- This is where continuous game updates would go
end

-- Cleanup game resources
function M.cleanup(game)
    logger.info("Cleaning up game: " .. game.id)
    
    -- Clean up any resources, save final state, etc.
end

-- Create a starter deck for new players
function create_starter_deck()
    -- This would be populated with actual starter cards
    -- For now, return an empty deck structure
    return deck_module.create({
        id = "starter_deck",
        name = "Basic Starter",
        cards = {} -- Will be populated with starter cards
    })
end

-- Create an AI deck based on difficulty
function create_ai_deck(difficulty)
    -- This would create different decks based on AI difficulty
    -- For now, return a basic deck
    return deck_module.create({
        id = "ai_deck_" .. difficulty.id,
        name = "AI " .. difficulty.name,
        cards = {} -- Will be populated with AI cards
    })
end

return M