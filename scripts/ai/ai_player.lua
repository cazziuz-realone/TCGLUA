-- AI Player Module
-- Implements artificial intelligence for computer opponents in SpireSmiths TCG
-- Uses various strategies and decision-making algorithms

local player_module = require "scripts.entities.player"
local card_module = require "scripts.entities.card"
local creature_module = require "scripts.entities.creature"
local logger = require "scripts.utils.logger"

local M = {}

-- AI Decision types
local DECISION_TYPES = {
    PLAY_CARD = "play_card",
    ATTACK = "attack",
    END_TURN = "end_turn",
    USE_HERO_POWER = "use_hero_power",
    MULLIGAN = "mulligan"
}

-- AI Strategies
local STRATEGIES = {
    AGGRESSIVE = "aggressive",     -- Focus on dealing damage to opponent
    CONTROL = "control",           -- Focus on board control and card advantage
    TEMPO = "tempo",               -- Focus on efficient mana usage and board presence
    DEFENSIVE = "defensive"        -- Focus on survival and late game
}

-- Difficulty-based AI configurations
local AI_CONFIGS = {
    [player_module.AI_DIFFICULTIES.EASY.id] = {
        thinking_time = 0.5,
        strategy = STRATEGIES.AGGRESSIVE,
        mistake_chance = 0.3,
        look_ahead_depth = 1,
        considers_opponent_hand = false,
        uses_card_synergies = false
    },
    [player_module.AI_DIFFICULTIES.MEDIUM.id] = {
        thinking_time = 1.0,
        strategy = STRATEGIES.TEMPO,
        mistake_chance = 0.15,
        look_ahead_depth = 2,
        considers_opponent_hand = true,
        uses_card_synergies = true
    },
    [player_module.AI_DIFFICULTIES.HARD.id] = {
        thinking_time = 1.5,
        strategy = STRATEGIES.CONTROL,
        mistake_chance = 0.05,
        look_ahead_depth = 3,
        considers_opponent_hand = true,
        uses_card_synergies = true
    },
    [player_module.AI_DIFFICULTIES.EXPERT.id] = {
        thinking_time = 2.0,
        strategy = STRATEGIES.CONTROL,
        mistake_chance = 0.0,
        look_ahead_depth = 4,
        considers_opponent_hand = true,
        uses_card_synergies = true
    }
}

-- Create an AI player instance
function M.create(player, difficulty)
    local ai_config = AI_CONFIGS[difficulty.id] or AI_CONFIGS[player_module.AI_DIFFICULTIES.MEDIUM.id]
    
    local ai_player = {
        player = player,
        difficulty = difficulty,
        config = ai_config,
        strategy = ai_config.strategy,
        current_plan = nil,
        decision_history = {},
        evaluation_cache = {}
    }
    
    logger.info(string.format("Created AI player: %s (Difficulty: %s, Strategy: %s)", 
        player.name, difficulty.name, ai_config.strategy))
    
    return ai_player
end

-- Make an AI decision for the current game state
function M.make_decision(ai_player, game_state)
    logger.debug("AI making decision...", "AI")
    
    local start_time = os.clock()
    local decision = nil
    
    -- Generate possible moves
    local possible_moves = generate_possible_moves(ai_player, game_state)
    
    if #possible_moves == 0 then
        -- No moves available, end turn
        decision = {
            type = DECISION_TYPES.END_TURN,
            reasoning = "No moves available"
        }
    else
        -- Evaluate and choose best move
        decision = choose_best_move(ai_player, game_state, possible_moves)
    end
    
    local decision_time = os.clock() - start_time
    
    -- Add artificial thinking time based on difficulty
    local thinking_time = ai_player.config.thinking_time
    if decision_time < thinking_time then
        timer.delay(thinking_time - decision_time, false, function()
            execute_ai_decision(ai_player, decision)
        end)
    else
        execute_ai_decision(ai_player, decision)
    end
    
    -- Log the decision
    logger.ai_decision(decision.type, decision.reasoning, decision.data)
    
    -- Store decision in history
    table.insert(ai_player.decision_history, {
        decision = decision,
        game_state_hash = hash_game_state(game_state),
        timestamp = os.time()
    })
    
    return decision
end

-- Generate all possible moves for the AI
function generate_possible_moves(ai_player, game_state)
    local moves = {}
    local current_player_state = game_state.players[game_state.current_player_index]
    
    -- Generate card play moves
    local playable_cards = player_module.get_playable_cards(current_player_state)
    for _, card in ipairs(playable_cards) do
        local card_moves = generate_card_play_moves(card, game_state)
        for _, move in ipairs(card_moves) do
            table.insert(moves, move)
        end
    end
    
    -- Generate attack moves
    local attack_moves = generate_attack_moves(current_player_state, game_state)
    for _, move in ipairs(attack_moves) do
        table.insert(moves, move)
    end
    
    -- Always include end turn as an option
    table.insert(moves, {
        type = DECISION_TYPES.END_TURN,
        data = {},
        estimated_value = 0
    })
    
    return moves
end

-- Generate card play moves for a specific card
function generate_card_play_moves(card, game_state)
    local moves = {}
    
    if card_module.is_creature(card) then
        -- Creature cards can be played if board isn't full
        local current_player_state = game_state.players[game_state.current_player_index]
        if not player_module.is_board_full(current_player_state) then
            table.insert(moves, {
                type = DECISION_TYPES.PLAY_CARD,
                data = {
                    card_id = card.id,
                    target = nil
                },
                estimated_value = evaluate_creature_play(card, game_state)
            })
        end
    elseif card_module.is_spell(card) then
        -- Spell cards might need targets
        local targets = find_valid_targets(card, game_state)
        if #targets == 0 then
            -- No target required or no valid targets
            table.insert(moves, {
                type = DECISION_TYPES.PLAY_CARD,
                data = {
                    card_id = card.id,
                    target = nil
                },
                estimated_value = evaluate_spell_play(card, nil, game_state)
            })
        else
            -- Generate moves for each valid target
            for _, target in ipairs(targets) do
                table.insert(moves, {
                    type = DECISION_TYPES.PLAY_CARD,
                    data = {
                        card_id = card.id,
                        target = target
                    },
                    estimated_value = evaluate_spell_play(card, target, game_state)
                })
            end
        end
    end
    
    return moves
end

-- Generate attack moves for creatures
function generate_attack_moves(player_state, game_state)
    local moves = {}
    local opponent_state = game_state.players[3 - game_state.current_player_index]
    
    for _, creature in ipairs(player_state.board) do
        if creature_module.can_attack(creature) then
            -- Can attack opponent's face
            table.insert(moves, {
                type = DECISION_TYPES.ATTACK,
                data = {
                    attacker_id = creature.instance_id,
                    target = "face"
                },
                estimated_value = evaluate_face_attack(creature, game_state)
            })
            
            -- Can attack opponent's creatures
            for _, enemy_creature in ipairs(opponent_state.board) do
                -- Check if we can attack this creature (Taunt rules, etc.)
                if can_attack_creature(creature, enemy_creature, opponent_state) then
                    table.insert(moves, {
                        type = DECISION_TYPES.ATTACK,
                        data = {
                            attacker_id = creature.instance_id,
                            target = enemy_creature.instance_id
                        },
                        estimated_value = evaluate_creature_attack(creature, enemy_creature, game_state)
                    })
                end
            end
        end
    end
    
    return moves
end

-- Choose the best move from available options
function choose_best_move(ai_player, game_state, possible_moves)
    -- Sort moves by estimated value
    table.sort(possible_moves, function(a, b)
        return a.estimated_value > b.estimated_value
    end)
    
    local best_move = possible_moves[1]
    
    -- Apply strategy-specific decision making
    if ai_player.strategy == STRATEGIES.AGGRESSIVE then
        best_move = choose_aggressive_move(possible_moves, game_state)
    elseif ai_player.strategy == STRATEGIES.CONTROL then
        best_move = choose_control_move(possible_moves, game_state)
    elseif ai_player.strategy == STRATEGIES.TEMPO then
        best_move = choose_tempo_move(possible_moves, game_state)
    elseif ai_player.strategy == STRATEGIES.DEFENSIVE then
        best_move = choose_defensive_move(possible_moves, game_state)
    end
    
    -- Apply difficulty-based mistakes
    if math.random() < ai_player.config.mistake_chance then
        best_move = apply_mistake(possible_moves, best_move)
    end
    
    best_move.reasoning = best_move.reasoning or ("Strategy: " .. ai_player.strategy)
    
    return best_move
end

-- Strategy-specific move selection functions
function choose_aggressive_move(moves, game_state)
    -- Prefer face damage and efficient trades
    for _, move in ipairs(moves) do
        if move.type == DECISION_TYPES.ATTACK and move.data.target == "face" then
            move.reasoning = "Aggressive: Direct damage to opponent"
            return move
        end
    end
    
    -- Fallback to highest value move
    moves[1].reasoning = "Aggressive: Best available move"
    return moves[1]
end

function choose_control_move(moves, game_state)
    -- Prefer board control and card advantage
    for _, move in ipairs(moves) do
        if move.type == DECISION_TYPES.PLAY_CARD then
            -- Prefer removal spells and high-value creatures
            move.reasoning = "Control: Board control priority"
            return move
        end
    end
    
    moves[1].reasoning = "Control: Best available move"
    return moves[1]
end

function choose_tempo_move(moves, game_state)
    -- Prefer efficient mana usage and board presence
    local current_player_state = game_state.players[game_state.current_player_index]
    
    -- Find moves that use mana efficiently
    for _, move in ipairs(moves) do
        if move.type == DECISION_TYPES.PLAY_CARD then
            move.reasoning = "Tempo: Efficient mana usage"
            return move
        end
    end
    
    moves[1].reasoning = "Tempo: Best available move"
    return moves[1]
end

function choose_defensive_move(moves, game_state)
    -- Prefer survival and defensive plays
    for _, move in ipairs(moves) do
        if move.type == DECISION_TYPES.ATTACK then
            -- Prefer defensive trades
            move.reasoning = "Defensive: Protective play"
            return move
        end
    end
    
    moves[1].reasoning = "Defensive: Best available move"
    return moves[1]
end

-- Apply difficulty-based mistakes
function apply_mistake(moves, best_move)
    -- Choose a suboptimal move
    local mistake_index = math.min(#moves, math.random(2, 4))
    local mistake_move = moves[mistake_index]
    mistake_move.reasoning = (mistake_move.reasoning or "") .. " (AI mistake)"
    return mistake_move
end

-- Evaluation functions for different move types
function evaluate_creature_play(card, game_state)
    local base_value = card_module.get_total_stats(card) - card.cost
    
    -- Bonus for keywords
    if card_module.has_keyword(card, "taunt") then
        base_value = base_value + 2
    end
    if card_module.has_keyword(card, "charge") then
        base_value = base_value + 1
    end
    
    return base_value
end

function evaluate_spell_play(card, target, game_state)
    -- Base evaluation for spell efficiency
    local base_value = 10 - card.cost
    
    -- Adjust based on target and effect
    if target then
        base_value = base_value + 2 -- Targeted spells often more valuable
    end
    
    return base_value
end

function evaluate_face_attack(creature, game_state)
    local opponent_state = game_state.players[3 - game_state.current_player_index]
    local damage = creature_module.get_effective_attack(creature)
    
    -- Higher value if opponent is low on health
    if opponent_state.health <= damage then
        return 100 -- Lethal damage
    end
    
    return damage * 2 -- Face damage is valuable
end

function evaluate_creature_attack(attacker, defender, game_state)
    local attacker_attack = creature_module.get_effective_attack(attacker)
    local defender_health = creature_module.get_effective_health(defender)
    
    local value = 0
    
    -- Value for destroying enemy creature
    if attacker_attack >= defender_health then
        value = value + defender_health + 5
    end
    
    -- Penalty for losing our creature
    local defender_attack = creature_module.get_effective_attack(defender)
    if defender_attack >= creature_module.get_effective_health(attacker) then
        value = value - (creature_module.get_effective_attack(attacker) + creature_module.get_effective_health(attacker))
    end
    
    return value
end

-- Helper functions
function find_valid_targets(card, game_state)
    -- This would implement target finding based on card effects
    -- For now, return empty list (no targeting)
    return {}
end

function can_attack_creature(attacker, defender, opponent_state)
    -- Check Taunt rules
    local has_taunt_creatures = false
    for _, creature in ipairs(opponent_state.board) do
        if creature_module.has_keyword(creature, "taunt") then
            has_taunt_creatures = true
            break
        end
    end
    
    if has_taunt_creatures then
        return creature_module.has_keyword(defender, "taunt")
    end
    
    return true
end

function execute_ai_decision(ai_player, decision)
    -- This would send the decision to the game controller
    logger.info("Executing AI decision: " .. decision.type)
    
    -- Send message to game controller with the decision
    msg.post("/game_controller#game_controller", "ai_decision", {
        player_id = ai_player.player.id,
        decision = decision
    })
end

function hash_game_state(game_state)
    -- Create a simple hash of the game state for caching
    -- This is a simplified version - a real implementation would be more sophisticated
    return string.format("%d_%d_%d", 
        game_state.turn, 
        game_state.current_player_index, 
        #game_state.history
    )
end

-- Mulligan decision for AI
function M.make_mulligan_decision(ai_player, hand)
    local cards_to_mulligan = {}
    
    for i, card in ipairs(hand) do
        -- Simple mulligan strategy: keep low-cost cards, mulligan high-cost cards
        if card.cost > 4 then
            table.insert(cards_to_mulligan, i)
        elseif card.cost == 0 and not card_module.is_creature(card) then
            -- Mulligan 0-cost spells (usually not good in opening hand)
            table.insert(cards_to_mulligan, i)
        end
    end
    
    logger.ai_decision("mulligan", string.format("Mulliganing %d cards", #cards_to_mulligan))
    
    return cards_to_mulligan
end

-- Get AI player statistics
function M.get_statistics(ai_player)
    return {
        difficulty = ai_player.difficulty.name,
        strategy = ai_player.strategy,
        decisions_made = #ai_player.decision_history,
        average_thinking_time = ai_player.config.thinking_time,
        mistake_chance = ai_player.config.mistake_chance
    }
end

return M