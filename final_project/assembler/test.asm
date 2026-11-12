# comments

# multiple comments
# in a row

# base instructions
nop
# registers
and $0 $r1 $r2
add $r3 $r4 $r5
lrs $r6 $r7 $r8
not $r9 $rA
or $rB $rC $rD
sub $rE $rF $zero
rot $r1 $r2 $r3
# immediate values
j $r4 "1"
imm $r5 "2"

l $r6 $r7
s $r8 $r9

cbz $rA "4"
cbnz $rB "8"
cbneg $rC "16"
cbnneg $rD "32"

# labels
label_a:
cbz $rE label_a

label_b:
cbz $rF label_b

# variables
def var_a
def var_b
# sized
def arr_a[5]
def arr_b[10]

imm $r0 var_a
imm $r1 var_b
imm $r2 arr_a
imm $r3 arr_b
