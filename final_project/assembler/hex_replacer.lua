-- loop though text file word by word.
-- Each word will be in the map "con_map" already.
-- Append the sting "code" with the hex value in the map.
-- Move on to the next word. 


-- table/map that has all the hex values for converting to hex.
-- lables will be added here
local con_map = {
    ["nop"]    = "0",
    ["j"]      = "1",
    ["l"]      = "2",
    ["w"]      = "3",
    ["cbz"]    = "4",
    ["cbnz"]   = "5",
    ["cbneg"]  = "6",
    ["cbnneg"] = "7",
    ["add"]    = "8",
    ["and"]    = "A",
    ["or"]     = "B",
    ["sub"]    = "C",
    ["s"]      = "D",
    ["not"]    = "E",
    ["rot"]    = "F",


	["$0"]  = "0",
    ["$r1"]  = "1",
    ["$r2"]  = "2",
    ["$r3"]  = "3",
    ["$r4"]  = "4",
    ["$r5"]  = "5",
    ["$r6"]  = "6",
    ["$r7"]  = "7",
    ["$r8"]  = "8",
    ["$r9"]  = "9",
    ["$r10"] = "A",
    ["$r11"] = "B",
    ["$r12"] = "C",
    ["$r13"] = "D",
    ["$r14"] = "E",
    ["$r15"] = "F"
}

-- output string
local code = ""

-- open file and copy it into a string
local file = io.open("test.txt", "r")
local text = file:read("*a")
file:close()

-- go word by word in the string and check to see if it is in the map
-- add it to the output if it exists, throw error if not
for word in text:gmatch("%S+") do
    local value = con_map[word:lower()]
    if value then
        code = code .. value
    else
        error("Unknown token: " .. word)
    end
end


--print the output
print(code)