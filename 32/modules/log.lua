-- v1.0
return function(message, level)
	level = level or 1
	local levels = {
		colors.white,
		colors.lime,
		colors.red
	}
	local originalColor = term.getTextColor()
	local colorChanged = (levels[level] ~= originalColor)

	io.write('*')
	term.setTextColor(colors.yellow)
	io.write(' [' .. textutils.formatTime(os.time(), true) .. '] ')
	term.setTextColor(originalColor)

	if levels[level] ~= nil and colorChanged then
		term.setTextColor(levels[level])
	end

	io.write(message .. '\n')

	if colorChanged then
		term.setTextColor(originalColor)
	end
end