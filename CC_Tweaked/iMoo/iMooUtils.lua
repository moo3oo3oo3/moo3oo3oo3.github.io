local utils = {}

function utils.clamp(number, minimum, maximum)
	local val = number < minimum and minimum or number
	return val > maximum and maximum or val
end

function utils.loopClamp(number, minimum, maximum)
	
	local range = maximum - minimum
	
	if number < minimum then
		local diff = minimum - number
		if diff > range then
			return utils.loopClamp(diff - range, minimum, maximum)
		end
		return maximum - diff + 1
	elseif number > maximum then
		local diff = number - maximum
		if diff > range then
			return utils.loopClamp(diff - range, minimum, maximum)
		end
		return minimum + diff - 1
	end
	
	return number
end

return utils