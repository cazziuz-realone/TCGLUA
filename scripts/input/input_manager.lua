-- Input Manager Module
-- Centralized input handling for SpireSmiths TCG
-- Manages different input contexts and action mapping

local logger = require "scripts.utils.logger"

local M = {}

-- Input contexts
local INPUT_CONTEXTS = {
    MENU = "menu",
    GAMEPLAY = "gameplay",
    DECK_BUILDER = "deck_builder",
    DIALOG = "dialog"
}

-- Current input context
local current_context = INPUT_CONTEXTS.MENU

-- Input action mappings for different contexts
local action_mappings = {
    [INPUT_CONTEXTS.MENU] = {
        [hash("click")] = "menu_click",
        [hash("touch")] = "menu_touch",
        [hash("key_escape")] = "menu_back",
        [hash("key_enter")] = "menu_confirm",
        [hash("key_space")] = "menu_confirm"
    },
    
    [INPUT_CONTEXTS.GAMEPLAY] = {
        [hash("click")] = "game_click",
        [hash("touch")] = "game_touch",
        [hash("key_escape")] = "game_menu",
        [hash("key_space")] = "end_turn",
        [hash("key_tab")] = "show_hand",
        [hash("key_1")] = "play_card_1",
        [hash("key_2")] = "play_card_2",
        [hash("key_3")] = "play_card_3",
        [hash("key_4")] = "play_card_4",
        [hash("key_5")] = "play_card_5",
        [hash("key_6")] = "play_card_6",
        [hash("key_7")] = "play_card_7",
        [hash("key_8")] = "play_card_8",
        [hash("key_9")] = "play_card_9",
        [hash("key_0")] = "play_card_10"
    },
    
    [INPUT_CONTEXTS.DECK_BUILDER] = {
        [hash("click")] = "deck_click",
        [hash("touch")] = "deck_touch",
        [hash("key_escape")] = "deck_back",
        [hash("key_ctrl")] = "deck_multi_select",
        [hash("key_shift")] = "deck_range_select",
        [hash("key_f")] = "deck_search",
        [hash("key_s")] = "deck_save"
    },
    
    [INPUT_CONTEXTS.DIALOG] = {
        [hash("click")] = "dialog_click",
        [hash("touch")] = "dialog_touch",
        [hash("key_escape")] = "dialog_cancel",
        [hash("key_enter")] = "dialog_confirm"
    }
}

-- Input listeners (functions that handle specific actions)
local input_listeners = {}

-- Touch/drag state
local touch_state = {
    is_touching = false,
    start_pos = vmath.vector3(),
    current_pos = vmath.vector3(),
    drag_threshold = 10, -- pixels
    is_dragging = false,
    drag_object = nil
}

-- Initialize input manager
function M.init()
    logger.info("Input Manager initialized")
    
    -- Set default context
    current_context = INPUT_CONTEXTS.MENU
    
    -- Initialize touch state
    touch_state.is_touching = false
    touch_state.is_dragging = false
    touch_state.drag_object = nil
end

-- Set the current input context
function M.set_context(context)
    if INPUT_CONTEXTS[context] then
        current_context = INPUT_CONTEXTS[context]
        logger.debug("Input context changed to: " .. context)
    else
        logger.warn("Unknown input context: " .. tostring(context))
    end
end

-- Get the current input context
function M.get_context()
    return current_context
end

-- Register an input listener for a specific action
function M.register_listener(action, callback)
    if not input_listeners[action] then
        input_listeners[action] = {}
    end
    table.insert(input_listeners[action], callback)
end

-- Unregister an input listener
function M.unregister_listener(action, callback)
    if input_listeners[action] then
        for i, listener in ipairs(input_listeners[action]) do
            if listener == callback then
                table.remove(input_listeners[action], i)
                break
            end
        end
    end
end

-- Process raw input and convert to game actions
function M.process_input(action_id, action)
    -- Get mapped action for current context
    local mapped_action = get_mapped_action(action_id)
    
    if mapped_action then
        -- Handle touch/drag logic
        if mapped_action:match("click") or mapped_action:match("touch") then
            handle_touch_input(mapped_action, action)
        end
        
        -- Trigger listeners for the mapped action
        trigger_action_listeners(mapped_action, action)
        
        return true
    end
    
    return false
end

-- Get mapped action for current context
function get_mapped_action(action_id)
    local context_mappings = action_mappings[current_context]
    if context_mappings and action_id then
        return context_mappings[action_id]
    end
    return nil
end

-- Handle touch/click input with drag detection
function handle_touch_input(mapped_action, action)
    if action.pressed then
        -- Start touch
        touch_state.is_touching = true
        touch_state.start_pos = vmath.vector3(action.x, action.y, 0)
        touch_state.current_pos = vmath.vector3(action.x, action.y, 0)
        touch_state.is_dragging = false
        touch_state.drag_object = nil
        
        trigger_action_listeners(mapped_action .. "_start", action)
        
    elseif action.released then
        -- End touch
        if touch_state.is_dragging then
            trigger_action_listeners(mapped_action .. "_drop", action)
        else
            trigger_action_listeners(mapped_action, action)
        end
        
        touch_state.is_touching = false
        touch_state.is_dragging = false
        touch_state.drag_object = nil
        
    elseif touch_state.is_touching then
        -- Touch move
        touch_state.current_pos = vmath.vector3(action.x, action.y, 0)
        
        -- Check if we should start dragging
        if not touch_state.is_dragging then
            local distance = vmath.length(touch_state.current_pos - touch_state.start_pos)
            if distance > touch_state.drag_threshold then
                touch_state.is_dragging = true
                trigger_action_listeners(mapped_action .. "_drag_start", action)
            end
        else
            -- Continue dragging
            trigger_action_listeners(mapped_action .. "_drag", action)
        end
    end
end

-- Trigger all listeners for an action
function trigger_action_listeners(action, input_action)
    if input_listeners[action] then
        for _, listener in ipairs(input_listeners[action]) do
            local success, result = pcall(listener, input_action)
            if not success then
                logger.error("Error in input listener for action " .. action .. ": " .. tostring(result))
            end
        end
    end
end

-- Set drag object (for card dragging, etc.)
function M.set_drag_object(object)
    touch_state.drag_object = object
end

-- Get current drag object
function M.get_drag_object()
    return touch_state.drag_object
end

-- Check if currently dragging
function M.is_dragging()
    return touch_state.is_dragging
end

-- Get touch position
function M.get_touch_position()
    return touch_state.current_pos
end

-- Get touch start position
function M.get_touch_start_position()
    return touch_state.start_pos
end

-- Helper function to check if a point is inside a rectangle
function M.point_in_rect(point_x, point_y, rect_x, rect_y, rect_width, rect_height)
    return point_x >= rect_x and point_x <= rect_x + rect_width and
           point_y >= rect_y and point_y <= rect_y + rect_height
end

-- Helper function to check if a point is inside a circle
function M.point_in_circle(point_x, point_y, circle_x, circle_y, radius)
    local dx = point_x - circle_x
    local dy = point_y - circle_y
    return (dx * dx + dy * dy) <= (radius * radius)
end

-- Convert screen coordinates to world coordinates
function M.screen_to_world(screen_x, screen_y)
    -- This would need to be implemented based on your camera setup
    -- For now, return the screen coordinates as-is
    return vmath.vector3(screen_x, screen_y, 0)
end

-- Convert world coordinates to screen coordinates
function M.world_to_screen(world_pos)
    -- This would need to be implemented based on your camera setup
    -- For now, return the world coordinates as-is
    return world_pos.x, world_pos.y
end

-- Create input action data
function M.create_action_data(action_type, data)
    local action_data = {
        type = action_type,
        timestamp = os.clock(),
        context = current_context
    }
    
    if data then
        for key, value in pairs(data) do
            action_data[key] = value
        end
    end
    
    return action_data
end

-- Cleanup input manager
function M.cleanup()
    logger.info("Input Manager cleanup")
    
    -- Clear all listeners
    input_listeners = {}
    
    -- Reset touch state
    touch_state.is_touching = false
    touch_state.is_dragging = false
    touch_state.drag_object = nil
end

return M