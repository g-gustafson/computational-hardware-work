maps = require "./maps"

---------------
-- FUNCTIONS --
---------------

function replace_by_map(text, map)
	for key, value in pairs(map) do
		text = string.gsub(text, key, value)
	end
	return text
end

function int_as_hex(value, length)
	local hex = string.format("%X", value)

	while #hex < length do
		hex = "0" .. hex
	end

	return hex
end

----------
-- MAIN --
----------

-- help text
if (arg[1] == "-h" or arg[1] == "--help") then
	print("lua assembler.lua input.s output.dat")
	os.exit()
end

-- verbosity
verbose = arg[3] == "-v" or arg[3] == "--verbose"

-- file directories
input_directory = arg[1]
output_directory = arg[2]

-- add file to buffer
buffer = ""

do
	local file = io.open(input_directory, "r")
	buffer = file:read("*all")
	file:close()
end

if verbose then
	print("\n\nINITIAL INPUT:\n")
	print(buffer)
end

-- preprocessing
buffer = replace_by_map(buffer, preprocess)
buffer = replace_by_map(buffer, pseudo_instructions)

buffer = "\n" .. buffer

buffer = replace_by_map(buffer, instruction_padding)

if verbose then
	print("\n\nPREPROCESSED:\n")
	print(buffer)
end

-- make conversion map
conversions = conversions_init

program_counter = 0
data_counter = 0

-- labels, variables
for line in buffer:gmatch("[^\n]+") do
	-- add label
	local label = line:match("([%w_%-%+%.]+):")
	if label then
		conversions[label] = int_as_hex(program_counter, 4)
	end

	local variable = line:match("def ([%w_%-%+%.]+)")
	local variable_width = line:match("def [%w_%-%+%.]+%[(%d+)%]")
	if variable then
		conversions[variable] = int_as_hex(data_counter, 4)
		if not variable_width then
			variable_width = "1"
		end
		print(variable_width)
		data_counter = data_counter + tonumber(variable_width);
	end

	-- instruction counting
	local first_word = line:match("^%s*(%a+)")
	if first_word and instruction_length_bytes[first_word] then
		program_counter = program_counter + instruction_length_bytes[first_word]
	end
end

-- remove definitions
buffer = string.gsub(buffer, "\n[%w_%-%+%.]+:", "")
buffer = string.gsub(buffer, "\ndef [%w_%-%+%.]+", "")
buffer = string.gsub(buffer, "%[%d+%]", "")

-- immediate values
for value in buffer:gmatch("\"(%d+)\"") do
	conversions["\"" .. value .. "\""] = int_as_hex(tonumber(value), 4)
end

-- variables

-- convert to hex
buffer = replace_by_map(buffer, conversions)

--format
buffer = string.gsub(buffer, "%s", "")
buffer = string.gsub(buffer, "(%x%x)", "%1\n")

if verbose then
	print("\n\nHEXADECIMAL:\n")
	print(buffer)
end

-- write result
do
	local file = io.open(output_directory, "w")
	file:write(buffer)
	file:close()
end
