-- Logger Utility Module
-- Provides logging functionality for SpireSmiths TCG
-- Handles different log levels and output formatting

local M = {}

-- Log levels
M.LEVELS = {
    DEBUG = 1,
    INFO = 2,
    WARN = 3,
    ERROR = 4,
    FATAL = 5
}

-- Current log level (only messages at this level or higher will be shown)
local current_log_level = M.LEVELS.INFO

-- Enable/disable logging
local logging_enabled = true

-- Log level names
local level_names = {
    [M.LEVELS.DEBUG] = "DEBUG",
    [M.LEVELS.INFO] = "INFO",
    [M.LEVELS.WARN] = "WARN",
    [M.LEVELS.ERROR] = "ERROR",
    [M.LEVELS.FATAL] = "FATAL"
}

-- Set the current log level
function M.set_level(level)
    current_log_level = level
end

-- Enable or disable logging
function M.set_enabled(enabled)
    logging_enabled = enabled
end

-- Format a log message
local function format_message(level, message, tag)
    local timestamp = os.date("%H:%M:%S")
    local level_name = level_names[level] or "UNKNOWN"
    tag = tag or "GAME"
    
    return string.format("[%s] %s [%s]: %s", timestamp, level_name, tag, tostring(message))
end

-- Core logging function
local function log(level, message, tag)
    if not logging_enabled or level < current_log_level then
        return
    end
    
    local formatted = format_message(level, message, tag)
    print(formatted)
end

-- Debug level logging
function M.debug(message, tag)
    log(M.LEVELS.DEBUG, message, tag)
end

-- Info level logging
function M.info(message, tag)
    log(M.LEVELS.INFO, message, tag)
end

-- Warning level logging
function M.warn(message, tag)
    log(M.LEVELS.WARN, message, tag)
end

-- Error level logging
function M.error(message, tag)
    log(M.LEVELS.ERROR, message, tag)
end

-- Fatal level logging
function M.fatal(message, tag)
    log(M.LEVELS.FATAL, message, tag)
end

-- Log game events
function M.game_event(event_type, message, data)
    local formatted_message = string.format("[%s] %s", event_type, message)
    if data then
        formatted_message = formatted_message .. " | Data: " .. tostring(data)
    end
    M.info(formatted_message, "GAME_EVENT")
end

-- Log AI decisions
function M.ai_decision(decision, reasoning, data)
    local formatted_message = string.format("AI Decision: %s | Reasoning: %s", decision, reasoning)
    if data then
        formatted_message = formatted_message .. " | Data: " .. tostring(data)
    end
    M.debug(formatted_message, "AI")
end

-- Log performance metrics
function M.performance(operation, duration, details)
    local formatted_message = string.format("Performance: %s took %.2fms", operation, duration * 1000)
    if details then
        formatted_message = formatted_message .. " | " .. details
    end
    M.debug(formatted_message, "PERF")
end

-- Log card actions
function M.card_action(player_id, action, card_name, target)
    local message = string.format("Player %s: %s %s", player_id, action, card_name)
    if target then
        message = message .. " targeting " .. target
    end
    M.info(message, "CARD")
end

-- Log UI events
function M.ui_event(event_type, details)
    local message = string.format("UI Event: %s", event_type)
    if details then
        message = message .. " | " .. details
    end
    M.debug(message, "UI")
end

-- Log errors with stack trace (if available)
function M.error_with_trace(message, error_obj)
    local full_message = message
    if error_obj then
        full_message = full_message .. " | Error: " .. tostring(error_obj)
    end
    
    -- In Lua, we can't easily get stack traces, but we can provide context
    local trace_info = debug.traceback()
    if trace_info then
        full_message = full_message .. "\nStack trace:\n" .. trace_info
    end
    
    M.error(full_message)
end

-- Assert with logging
function M.assert(condition, message, tag)
    if not condition then
        local error_message = message or "Assertion failed"
        M.error(error_message, tag or "ASSERT")
        error(error_message)
    end
end

-- Log function entry/exit for debugging
function M.trace_function(func_name, func)
    return function(...)
        M.debug("Entering function: " .. func_name, "TRACE")
        local start_time = os.clock()
        
        local results = {func(...)}
        
        local duration = os.clock() - start_time
        M.debug(string.format("Exiting function: %s (%.2fms)", func_name, duration * 1000), "TRACE")
        
        return unpack(results)
    end
end

-- Create a logger for a specific module
function M.create_module_logger(module_name)
    return {
        debug = function(message) M.debug(message, module_name) end,
        info = function(message) M.info(message, module_name) end,
        warn = function(message) M.warn(message, module_name) end,
        error = function(message) M.error(message, module_name) end,
        fatal = function(message) M.fatal(message, module_name) end
    }
end

-- Initialize logger with configuration
function M.init(config)
    config = config or {}
    
    if config.level then
        M.set_level(config.level)
    end
    
    if config.enabled ~= nil then
        M.set_enabled(config.enabled)
    end
    
    M.info("Logger initialized", "LOGGER")
end

return M