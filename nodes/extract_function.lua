---For Pixel Composer Use
---node = Lua Compute
---node_parameters = (
---     node_content: string,
---     node_path: string,
---     node_function_name: string | "",
--- )
---node_export = type {string, string}

---Converts a string to an array
---@param string_to_be_split string
---@param delimiter string
---@return table | nil
local function split(string_to_be_split, delimiter)
    if type(string_to_be_split) ~= "string" then return nil end
    if type(delimiter) ~= "string" then return nil end
    if #string_to_be_split == 0 then return nil end
    if #delimiter == 0 then return nil end

    local result = {}
    for i in string_to_be_split:gmatch("([^".. delimiter .."]+)") do
        table.insert(result, i)
    end
    return result
end

---Gets the function name from the filename
---@param path string
---@return string | nil
local function get_function_name_from_filename(path)
    if type(path) ~= "string" then return nil end
    if #path == 0 then return nil end

    local file_seperator = package.config:sub(1, 1)
    local directory = split(path, file_seperator)
    if not directory then return nil end
    local file_split = split(directory[#directory], "%.")
    if not file_split then return nil end
    return file_split[1]
end

---Gets the function parameters from a Lua file
---@param function_name string
---@param lua_content string
---@return table | nil
local function get_function_parameter(function_name, lua_content)
    if type(function_name) ~= "string" then return nil end
    if type(lua_content) ~= "string" then return nil end
    if #function_name == 0 then return nil end
    if #lua_content == 0 then return nil end

    local lines = split(lua_content, "\n")
    if not lines then return nil end

    local function_line = nil
    for _, v in ipairs(lines) do
        if v:find("function " .. function_name) then
            function_line = v
            break
        end
    end
    if not function_line then return nil end

    local param = function_line:match("%((.-)%)")
    if param then
        if #param == 0 then
            return {}
        end
        local param_list = split(param, ",")
        return param_list
    end
    return nil
end

---Returns as "function_name(function_parameter1,function_parameter2,...)"
---@param function_name string
---@param function_parameter table
---@return string | nil
local function build_function(function_name, function_parameter)
    if type(function_name) ~= "string" then return nil end
    if type(function_parameter) ~= "table" then return nil end
    if #function_name == 0 then return nil end

    local result = string.format("%s(", function_name)
    for i, v in ipairs(function_parameter) do
        result = result .. v
        if i < #function_parameter then
            result = result .. ","
        end
    end
    result = result .. ")"
    return result
end

local function try_node_function_name(node_function_name, node_path)
    if type(node_function_name) ~= "string" or #node_function_name == 0 then
        return get_function_name_from_filename(node_path)
    end
    return node_function_name
end

local function_name = try_node_function_name(node_function_name, node_path)
local function_param = get_function_parameter(function_name, node_content)
local export_function = build_function(function_name, function_param)

if not export_function then
    return {function_name, "---Could not find function!"}
end

local lua_code = node_content .. "\nreturn " .. export_function

return {function_name, lua_code}
