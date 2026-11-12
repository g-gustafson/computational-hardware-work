# take in 2 registers (1 for year 1 50/50 split w/ month and date)
# approximate 52 weeks in a year 4 weeks in a month
# r1 = birth year register
# r2 = birt month/day register (mmdd)
# rA = output numbers of days alive
# total_days = ((cur_yr - birth_yr)/52) + ((curr_mth-birth_mth)/4) + (curr_dy-birthday)

# 0FFA _switches_
# 0FFB _buttons_
# 0FFC _leds_
# 0FFD _seven_seg_low_
# 0FFE _seven_seg_high_
# 0FFF _program_counter_

# add switch
add rE $0 _switches_
# add button
add rF $0 _buttons_

# load buttons
l rD rF
# button0 load year
add rC $0 1
and rB rD rC

beq rB $0 CHECK_BUTTON1

# load switches into r1
l r1 rE

CHECK_BUTTON1:

add rC $0 2
and rB rD rC

beq rB $0 CONTINUE

# load switches into r2
l r2 rE

CONTINUE:

# Curr date
add r6 $0 2026       # current year
add r7 $0 5          # current month
add r8 $0 12         # current day

# Day mask
not r3 $0
lrs r3 r3 8

# Extract birth day
and r4 r2 r3
# Extract birth month
lrs r5 r2 8

# Year diff
sub r9 r6 r1

# rA = year * 256
add rB $0 8
lsl rA r9 rB

# + year * 64
add rB $0 6
lsl rC r9 rB
add rA rA rC

# + year * 32
add rB $0 5
lsl rC r9 rB
add rA rA rC

# + year * 8
add rB $0 3
lsl rC r9 rB
add rA rA rC

# + year * 4
add rB $0 2
lsl rC r9 rB
add rA rA rC

# + year
add rA rA r9

# Month diff
sub rB r7 r5

# *16
add rC $0 4
lsl rD rB rC

# *8
add rC $0 3
lsl r9 rB rC
add rD rD r9

# *4
add rC $0 2
lsl r9 rB rC
add rD rD r9

# *2
add rC $0 1
lsl r9 rB rC
add rD rD r9

# add month contribution
add rA rA rD

# Day diff
sub rD r8 r4

# add day contribution
add rA rA rD

add rE $0 0x0FFC
# write outputs to LEDS
w rA rE