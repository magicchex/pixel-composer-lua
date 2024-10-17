---Assuming it is a rectangular shape it will get
---the location of a cell
---the dimension
---the area
---@param node_width any
---@param node_idx any
---@return table
function get_cell_location(node_width, node_idx):
    local tile_x = node_idx % node_width
    local tile_y = math.floor(node_idx / node_width)
    local height = math.ceil(node_idx / node_width)
    local position = {tile_x, tile_y}
    local dimension = {node_width, height}
    local area = node_width*height
    return {position, dimension, area}
end
