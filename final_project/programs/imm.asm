add $0 $0 $0

cbz $0 test

imm $r1 "5"

test:

imm $r2 "4"

imm $r9 "3"

sub $0 $r9 $0

cbnz $0 test_2

imm $rF "1"

test_2:

imm $rF "16"

