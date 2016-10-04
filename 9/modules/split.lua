-- v1.0.2
return function(str)
	if type(str) ~= 'string' then return end

	local tbl = {}
	local i = 1
	for word in string.gmatch(str, "%S+") do
	  tbl[i] = word
	  i = i + 1
	end
	return tbl
end