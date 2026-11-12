# this file is to test the IO for the program

# assuming that there is a value in the input memory address FF or "255" as an int

# infinate loop that checks if something is inputed inot the value
imm $r2 "0"
loop: 
# that line should load r1 with the memory address for the input 
imm $r1 "255"
nop

# this line should load the input value into the regester r2
l $r2 $r1
nop
sub $0 $r2 $0
cbz $rF loop

nop
run_i:
nop
j $0 run_i
