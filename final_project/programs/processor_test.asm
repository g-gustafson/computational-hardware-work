
# NOP
nop

# AND
imm $r2 "3"
imm $r3 "5"
and $r1 $r2 $r3

# ADD
imm $r3 "1"
add $r2 $r3 $r3

# LRS
add $r4 $0 $r3
lrs $r3 $r2 $r4
add $r4 $0 $r3
and $r3 $r2 $r4

# NOT
imm $r5 "65531"
# 0xFFFB
not $r4 $r5

# OR
or $r5 $r1 $r4

# SUB
imm $r7 "11"
sub $r6 $r7 $r5

# ROT
imm $r8 "49153"
# 0xC001
imm $r9 "14"
rot $r7 $r8 $r9



# J
j $0 j_test
nop
j_return:

# IMM
imm $r9 "9"

# L, S
imm $rB "10"
def ls_test
imm $rA ls_test
s $rA $rB
add $rC $0 $rA
l $rA $rC
add $rB $rA $r1

# CBZ
cbz $0 end
nop
imm $rC "12"

# CBNZ
sub $0 $r1 $0
cbnz $0 cbnz_test
nop
j $0 end
nop
cbnz_test:
imm $rD "13"

# CBNEG
sub $0 $r1 $r2
cbneg $0 cbneg_test
nop
j $0 end
nop
cbneg_test:
imm $rE "14"

# CBNNEG
sub $0 $r3 $r4
cbnneg $0 end
imm $rF "15"

# end program
j $0 end
nop
j_test:
imm $r8 "8"
j $0 j_return
nop

end:
nop

j $0 end
nop