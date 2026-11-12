## Hardware Specifications

### General
|                     |         |
|:--------------------|--------:|
| Word Size           |  16 bit |
| Mutable Registers   |     15* |
| Memory Address Size |  16 bit |
| Architecture        | Harvard |

*There is also a zero register

### Hardware Instruction Set
| Opcode | Mnemonic | Parameters | Length (bytes) |
|:------:|:---------|:-----------|---------------:|
|  0000  | nop      | -          |              1 |
|  0001  | and      | rY, rA, rB |              2 |
|  0010  | add      | rY, rA, rB |              2 |
|  0011  | lrs      | rY, rA, rB |              2 |
|  0100  | not      | rY, -, rA  |              2 |
|  0101  | or       | rY, rA, rB |              2 |
|  0110  | sub      | rY, rA, rB |              2 |
|  0111  | rot      | rY, rA, rB |              2 |
|  1000  | j        | rY, addr   |              3 |
|  1001  | imm      | rY, imm    |              3 |
|  1010  | l        | rY, rA, -  |              2 |
|  1011  | s        | -, rA, rY  |              2 |
|  1100  | cbz      | rRA, addr  |              3 |
|  1101  | cbnz     | rRA, addr  |              3 |
|  1110  | cbneg    | rRA, addr  |              3 |
|  1111  | cbnneg   | rRA, addr  |              3 |

s is (where, what)
l is (where store, from where in mem)
## Control Signals

| Mnemonic | Opcode | ALU | DATA_W | FLAG_SEL | IMM_W | REG_W_SRC | DO_BRANCH | DO_JUMP | INSTR_LEN  |
|:---------|:------:|:---:|:------:|:--------:|:-----:|:---------:|:---------:|:-------:|:----------:|
| nop      |  0000  |  -  |   0    |    -     |   -   |     -     |     -     |    0    |     01     |
| and      |  0001  | 001 |   0    |    -     |   0   |     0     |     0     |    0    |     10     |
| add      |  0010  | 010 |   0    |    -     |   0   |     0     |     0     |    0    |     10     |
| lrs      |  0011  | 011 |   0    |    -     |   0   |     0     |     0     |    0    |     10     |
| not      |  0100  | 100 |   0    |    -     |   0   |     0     |     0     |    0    |     10     |
| or       |  0101  | 101 |   0    |    -     |   0   |     0     |     0     |    0    |     10     |
| sub      |  0110  | 110 |   0    |    -     |   0   |     0     |     0     |    0    |     10     |
| rot      |  0111  | 111 |   0    |    -     |   0   |     0     |     0     |    0    |     10     |
| j        |  1000  |  -  |   0    |    -     |   0   |     1     |     1     |    1    |     11     |
| imm      |  1001  |  -  |   0    |    -     |   1   |     0     |     0     |    0    |     11     |
| l        |  1010  |  -  |   0    |    -     |   0   |     1     |     0     |    0    |     10     |
| s        |  1011  |  -  |   1    |    -     |   0   |     0     |     0     |    0    |     10     |
| cbz      |  1100  |  -  |   0    |    00    |   0   |     1     |     1     |    0    |     11     |
| cbnz     |  1101  |  -  |   0    |    01    |   0   |     1     |     1     |    0    |     11     |
| cbneg    |  1110  |  -  |   0    |    10    |   0   |     1     |     1     |    0    |     11     |
| cbnneg   |  1111  |  -  |   0    |    11    |   0   |     1     |     1     |    0    |     11     |

### ALU
| Bit(s) | Function                                      |
|:------:|:----------------------------------------------|
|   2    | Negation, (and, or), (shift, rotate)           |
|  1:0   | Mux (unary, bitwise, arithmetic, associative) |

| Code | Operation  |
|:----:|:-----------|
| 000  | B (unused) |
| 001  | A and B    |
| 010  | A + B      |
| 011  | A >> B     |
| 100  | not B      |
| 101  | A or B     |
| 110  | A - B      |
| 111  | A rot B    |

### DATA_W 
| Bit(s) | Function                 |
|:------:|:-------------------------|
|   0    | Can write to Data Memory |

### FLAG_SEL 
| Bit(s) | Function       |
|:------:|:---------------|
|   1    | Zero, Negative |
|   0    | Negation       |

### IMM_W
| Bit(s) | Function                            |
|:------:|:------------------------------------|
|   0    | Immediate value written to register |

### REG_W_SRC
| Bit(s) | Function                             |
|:------:|:-------------------------------------|
|   0    | (ALU, Data Memory) to register write |

### DO_BRANCH
| Bit(s) | Function                     |
|:------:|:-----------------------------|
|   0    | determines if branch command |

### INSTR_LEN
|  Bit(s)  | Function              |
|:--------:|:----------------------|
|   4:0    | increment pc by value |

## Hardware Components

## Misc

### Data Memory Mappings 
| Address | Maps to         |
|:-------:|:----------------|
|  0000   | Program counter |

### Psuedo Instructions
```
WRITTEN            | ASSEMBLED
                   |
lls rY rA rB       | sub rB $0 rB
                   | lrs rY rA rB
                   | sub rB $0 rB
                   |
lw rY addr         | imm rY addr
                   | l   rY rY
                   |
sw rY addr         | imm $15 addr
                   | s   rY $15
                   |
beq rRA rA rB addr | sub $0 rA rB
                   | cbz rRA addr
                   |
bne rRA rA rB addr | sub  $0 rA rB
                   | cbnz rRA addr
                   |
bgt rRA rA rB addr | sub   $0 rB rA
                   | cbneg rRA addr
                   |
blt rRA rA rB addr | sub   $0 rA rB
                   | cbneg rRA addr
                   |
bge rRA rA rB addr | sub    $0 rA rB
                   | cbnneg rRA addr
                   |
ble rRA rA rB addr | sub    $0 rB rA
                   | cbnneg rRA addr
```
