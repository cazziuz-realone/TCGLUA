-- Scene Manager Module
-- Manages different UI scenes and transitions in SpireSmiths TCG
-- Handles loading, unloading, and switching between game scenes

local logger = require "scripts.utils.logger"

local M = {}

-- Scene definitions
local SCENES = {
    main_menu = {
        gui_url = "/gui/main_menu.gui",
        collection_url = nil,
        persistent = false
    },
    gameplay = {
        gui_url = "/gui/game_board.gui",
        collection_url = "/collections/game.collection",
        persistent = false
    },
    deck_builder = {
        gui_url = "/gui/deck_builder.gui",
        collection_url = nil,
        persistent = false
    },
    game_setup = {
        gui_url = "/gui/game_setup.gui",
        collection_url = nil,
        persistent = false
    },
    game_over = {
        gui_url = "/gui/game_over.gui",
        collection_url = nil,
        persistent = false
    }
}

-- Current scene state
local current_scene = nil
local scene_stack = {}
local transition_in_progress = false

-- Scene transition types
local TRANSITION_TYPES = {
    FADE = "fade",
    SLIDE = "slide",
    INSTANT = "instant"
}

-- Initialize scene manager
function M.init()
    logger.info("Scene Manager initialized")
    
    -- Initialize scene stack
    scene_stack = {}
    current_scene = nil
    transition_in_progress = false
end

-- Load a scene
function M.load_scene(scene_name, transition_type, transition_duration)
    if transition_in_progress then
        logger.warn("Scene transition already in progress, ignoring load request for: " .. scene_name)
        return nil
    end
    
    local scene_config = SCENES[scene_name]
    if not scene_config then
        logger.error("Unknown scene: " .. scene_name)
        return nil
    end
    
    logger.info("Loading scene: " .. scene_name)
    
    transition_type = transition_type or TRANSITION_TYPES.FADE
    transition_duration = transition_duration or 0.5
    
    transition_in_progress = true
    
    -- Start transition out of current scene
    if current_scene then
        transition_out_current_scene(transition_type, transition_duration, function()
            complete_scene_load(scene_name, scene_config, transition_type, transition_duration)
        end)
    else
        complete_scene_load(scene_name, scene_config, transition_type, transition_duration)
    end
    
    return scene_name
end

-- Complete scene loading after transition out
function complete_scene_load(scene_name, scene_config, transition_type, transition_duration)
    -- Unload previous scene
    if current_scene then
        unload_current_scene()
    end
    
    -- Load new scene
    current_scene = {
        name = scene_name,
        config = scene_config,
        gui_instance = nil,
        collection_instance = nil
    }
    
    -- Load collection if specified
    if scene_config.collection_url then
        msg.post(scene_config.collection_url, "load")
        current_scene.collection_instance = scene_config.collection_url
    end
    
    -- Load GUI
    if scene_config.gui_url then
        msg.post(scene_config.gui_url, "enable")
        current_scene.gui_instance = scene_config.gui_url
    end
    
    -- Transition in new scene
    transition_in_current_scene(transition_type, transition_duration, function()
        transition_in_progress = false
        logger.info("Scene transition completed: " .. scene_name)
    end)
end

-- Unload current scene
function unload_current_scene()
    if not current_scene then return end
    
    logger.info("Unloading scene: " .. current_scene.name)
    
    -- Unload GUI
    if current_scene.gui_instance then
        msg.post(current_scene.gui_instance, "disable")
    end
    
    -- Unload collection
    if current_scene.collection_instance then
        msg.post(current_scene.collection_instance, "unload")
    end
end

-- Unload a specific scene
function M.unload_scene(scene_name)
    if current_scene and current_scene.name == scene_name then
        unload_current_scene()
        current_scene = nil
    end
end

-- Push current scene to stack and load new scene
function M.push_scene(scene_name, transition_type, transition_duration)
    if current_scene then
        table.insert(scene_stack, current_scene)
    end
    
    return M.load_scene(scene_name, transition_type, transition_duration)
end

-- Pop scene from stack and return to it
function M.pop_scene(transition_type, transition_duration)
    if #scene_stack == 0 then
        logger.warn("No scenes in stack to pop")
        return nil
    end
    
    local previous_scene = table.remove(scene_stack)
    return M.load_scene(previous_scene.name, transition_type, transition_duration)
end

-- Get current scene name
function M.get_current_scene()
    return current_scene and current_scene.name or nil
end

-- Check if a scene is loaded
function M.is_scene_loaded(scene_name)
    return current_scene and current_scene.name == scene_name
end

-- Handle input for current scene
function M.handle_input(action_id, action)
    if current_scene and current_scene.gui_instance then
        -- Forward input to current scene's GUI script
        -- This would be handled by the GUI script itself
        return false
    end
    return false
end

-- Update scene manager
function M.update(dt)
    -- Handle any continuous scene updates
    if current_scene then
        -- Update current scene if needed
    end
end

-- Show pause menu overlay
function M.show_pause_menu()
    -- This would show a pause menu overlay without changing the current scene
    logger.info("Showing pause menu")
    
    -- Create pause menu GUI overlay
    -- Implementation would depend on how overlays are handled
end

-- Hide pause menu overlay
function M.hide_pause_menu()
    logger.info("Hiding pause menu")
    
    -- Hide pause menu GUI overlay
end

-- Transition out of current scene
function transition_out_current_scene(transition_type, duration, callback)
    if not current_scene or not current_scene.gui_instance then
        if callback then callback() end
        return
    end
    
    logger.debug("Transitioning out scene: " .. current_scene.name .. " (" .. transition_type .. ")")
    
    if transition_type == TRANSITION_TYPES.FADE then
        -- Fade out animation
        -- This would need to be implemented with specific GUI nodes
        timer.delay(duration, false, callback)
    elseif transition_type == TRANSITION_TYPES.SLIDE then
        -- Slide out animation
        timer.delay(duration, false, callback)
    else -- INSTANT
        if callback then callback() end
    end
end

-- Transition in to current scene
function transition_in_current_scene(transition_type, duration, callback)
    if not current_scene then
        if callback then callback() end
        return
    end
    
    logger.debug("Transitioning in scene: " .. current_scene.name .. " (" .. transition_type .. ")")
    
    if transition_type == TRANSITION_TYPES.FADE then
        -- Fade in animation
        timer.delay(duration, false, callback)
    elseif transition_type == TRANSITION_TYPES.SLIDE then
        -- Slide in animation
        timer.delay(duration, false, callback)
    else -- INSTANT
        if callback then callback() end
    end
end

-- Register a new scene type
function M.register_scene(scene_name, scene_config)
    SCENES[scene_name] = scene_config
    logger.info("Registered scene: " .. scene_name)
end

-- Cleanup scene manager
function M.cleanup()
    logger.info("Scene Manager cleanup")
    
    -- Unload current scene
    if current_scene then
        unload_current_scene()
        current_scene = nil
    end
    
    -- Clear scene stack
    scene_stack = {}
    transition_in_progress = false
end

return M