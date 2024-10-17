---Search up "arithmetic sequence" on Google for explaination
---@param node_starting_term number
---@param node_common_difference number
---@param node_idx integer
---@return number
function arithmetic_sequence(node_starting_term, node_common_difference, node_idx)
    return node_starting_term+(node_idx-1)*node_common_difference
end