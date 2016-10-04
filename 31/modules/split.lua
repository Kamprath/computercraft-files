return function(string)
	local tbl = {}
	local i = 1
	for word in string.gmatch(string, "%S+") do
	  tbl[i] = word
	  i = i + 1
	end
	return tbl
end