preprocess = {
	-- comments
	["#.-\n"] = "",
	-- whitespace
	["%s*\n"] = "\n",
	["\t"]    = "",
	-- normalize registers
	["$0"] = "$r0",
	["$zero"] = "$r0",
}

pseudo_instructions = {
	-- regex go brrr

    -- beq a, b, label: branch if a = b
	["\nbeq ($r%x) ($r%x) (%a-\n)"] = "\nsub $0 %1 %2\ncbz %3",

	-- bne a, b, label: branch if a ~= b
    ["\nbne ($r%x) ($r%x) (%a-\n)"] = "\nsub $0 %1 %2\ncbnz %3",

	-- bgt a, b, label: branch if a > b
    ["\nbgt ($r%x) ($r%x) (%a-\n)"] = "\nsub $0 %2 %1\ncbneg %3",

	-- blt a, b, label: branch if a < b
    ["\nblt ($r%x) ($r%x) (%a-\n)"] = "\nsub $0 %1 %2\ncbneg %3",

	-- bge a, b, label: branch if a >= b
    ["\nbge ($r%x) ($r%x) (%a-\n)"] = "\nsub $0 %1 %2\ncbnneg %3",

	-- ble a, b, label: branch if a <= b
    ["\nble ($r%x) ($r%x) (%a-\n)"] = "\nsub $0 %2 %1\ncbnneg %3",
}

instruction_padding = {
	["\nnop"]  = "\nnop $r0",
	["\nnot ($r%x) ($r%x)"] = "\nnot %1 $r0 %2",
	["\nl ($r%x) ($r%x)"] = "\nl %1 %2 $r0",
	["\ns ($r%x) ($r%x)"]  = "\ns $r0 %1 %2",
}

conversions_init = {
	-- instructions
	["\nnop "]    = "\n0 ",
	["\nand "]    = "\n1 ",
	["\nadd "]    = "\n2 ",
	["\nlrs "]    = "\n3 ",
	["\nnot "]    = "\n4 ",
	["\nor "]     = "\n5 ",
	["\nsub "]    = "\n6 ",
	["\nrot "]    = "\n7 ",
	["\nj "]      = "\n8 ",
	["\nimm "]    = "\n9 ",
	["\nl "]      = "\nA ",
	["\ns "]      = "\nB ",
	["\ncbz "]    = "\nC ",
	["\ncbnz "]   = "\nD ",
	["\ncbneg "]  = "\nE ",
	["\ncbnneg "] = "\nF ",
	-- registers
	["$r(%x)"] = "%1",
}

instruction_length_bytes = {
	["nop"]    = 1,
	["and"]    = 2,
	["add"]    = 2,
	["lrs"]    = 2,
	["not"]    = 2,
	["or"]     = 2,
	["sub"]    = 2,
	["rot"]    = 2,
	["j"]      = 3,
	["imm"]    = 3,
	["l"]      = 2,
	["s"]      = 2,
	["cbz"]    = 3,
	["cbnz"]   = 3,
	["cbneg"]  = 3,
	["cbnneg"] = 3,
}

