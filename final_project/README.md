# CS385-1 Computational Hardware Final Project
## FP3: Control Unit Design

# Introduction    
In this lab you will finish your processor by completing these activities

* Design and implement the main *Control Unit (CU)* for your processor.  
* Design and implement *Input/Output (I/O)* for your processor.
* Implement a working test program that demonstrates your processor's Input/output.
* Deliver a final presentation and an individual reflection.

## Control Unit Design

The goal of this lab will be to design a CU that correctly interprets and executes your machine code instructions that you designed in FP1. Recall that an instruction is fetched from memory, and, the control unit recieves the **instruction opcode** signal bits of the current instruction. Typically, the current instruction that is executing is held steady in an **Instruction Register** and the opcode bits from this register connect to the CU. Based on the instruction, the CU outputs appropriate control signals that tell each indvidual component of the DPU exactly what to do (and when to do it).  A CU controls the "Decode" and "Execute" phases of an instruction's life-cycle.  

## Processor Design Choices

There are many different design choices you have available to you at this point depeneding on the type of processor you are constructing. Some of your choices are:

* Single-cycle or Multi-cycle Machine?
* Pipelined or no Pipeline?
* Multiple ALUs or single ALU?

Single-cycle machines without pipelines have much simpler control units than multi-cycle or pipelined machines. A multi-cycle/pipelined machine requires a finite state machine control unit, while in contrast, a single-cycle machine without pipelining only requires the much simpler "decoder" as we saw in the MIPS single-cycle processor design.

* In a *single-cycle machine*, the control unit is just a fancy *look-up ROM* that acts somewhat like a python dictionary or a C++ map.  The instruction op-code functions serves as the input "key" and the control unit then returns the "value" (i.e. the set of control signals sent to the control bus) that control each component in the DPU. The *control bus* consists of the set of wires that carry control signals from the CU to each component in the Data Path Unit (DPU). Each instruction's opcode will result in a specific set of control signals that cause the components in the DPU to behave in a manner appropriate to the instruction currently being executed.

* In a *multi-cycle machine* or *pipelined machine*, the control unit is built using a *finite state machine (FSM)*.  In this case, each instruction op-code triggers the FSM to proceed through a series of control states. Specific control signals (the outputs of the FSM) are associated with each state of the FSM. All of the instructions share the same "fetch" control state of the FSM, but, after decoding, each individual instruction will step through a specific set of control states required to execute that instruction (although different instructions can share common states if needed). Each individual control state generates a specific set of control signals that control the components in the DPU necessary for the given instruction. Some instructions require more control states than others and thus take longer to execute. It is possible to desgin control units using a lower level language known as microcode. Then, writing a control unit is like writing an assembly program using the microcode instructions.

## Input/Output Design Choices

Your processor must have the ability to interact with the external world. In addition to complement the Control Unit, your group must integrate both __input__ and __output__ for your processor. To recieve above a 90% for this project your group must successfully implement an advanced form of input and and advance forme of output beyond the simple forms of I/O that every group must implement. 

Simple I/O that every group must implement for a passing project grade (implement ALL of these):
* 16 switches (or push buttons) 16 Lights/LEDs   
* HEX display output

Advanced output must implement at least one of: 
* 2D Display (e.g. VGA) output,  
* SPI port output, 
* Serial terminal output,
* External output device of groups choosing and verified with instructor.

Advanced input must implement at least one of: 
* External Keyboard input, 
* SPI (joystick) input, 
* Serial terminal input,
* External input device of groups choosing and verified with instructor.

Only certain keyboards will work well for keyboard input (there are some simple keyboards in the cardboard box in 304 that you can use as, please leave these in the lab for others to use and put them back in the cardboard box when you are finished).

In the past groups have made games, interactive programs, etc. Other groups have made video generators that allow the program to output text (most challenging).

In general, you want to make a project that can show off the capabilities of your processor. 


## 25 pts. Section 1: Control Unit (CU) Design
The controller is the portion of the CU that looks at the opcode and determines the output signals. As described above, it is a map that links instructions to the activation of the appropriate control signals for that instruction.  Have your Assembly Language, ALU, and DPU designs easily accessible while you work on this design. 

Decide if your group will designing a single cycle or multi-cycle machine. Complete the appropriate table/diagram for the type of machine you are designing at put it in figure 1 below.

### Figure 1 Control Unit Design Architecture (10 pts)

If you are creating a single cycle processor, create a table in Fig. 1 with one row for each of your instructions. You can see Table 7.3 on page 384 of the textbook for an example of what this might look like for your processor.  Basically this is just a simply a list of opcodes followed by all the control signals activated for those opcodes. You have already seen a table like this in the MIPS projects. Use as many columns as needed for your control signals.

If you have a multi-state controller FSM you will need a diagram to illustrate the multiple states.  Create a state diagram (a bubble diagram as illustrated in lecture for the multicycle machine) that clearly shows the states required for each instruction (or if you are doing a complex processor the states required to make it work). 

```
    *********************************************************************
    Fig. 1 Control Unit Design Table or Bubble Diagram
    *********************************************************************
we have all of our stuff in the documentation.md file for this and the diagram is in the following link:

https://lucid.app/lucidchart/98fe40a6-3dd5-448b-818f-7c1129f42d32/edit?viewport_loc=93%2C-284%2C1823%2C1097%2C0_0&invitationId=inv_362f2a83-8f18-4276-8e7a-d521352396f3

    Include your table or FSM diagram here

```
### Simulation Test Bench: Verification of Control Unit (15 pts)

Create a simulation testbench that verifies your processor loads the test program you have designed, and executes the instructions correctly. 
* You MUST verify that all branch/jump statements work correctly in both ways (i.e. dont jump/do jump under appropriate conditions)
* Your simulation testbench code MUST output informational messages if a test fails and outputs a passing message if all tests passed successfully.

```vhdl

    --*********************************************************************
    --Fig. 2 Simulation Testbench Code 
    --*********************************************************************


    library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity greg_testbench is
end;

architecture greg_testbench of greg_testbench is

    component greg is -- top-level design for testing
      generic(
        data_width: integer;
        reg_addr_width: integer
      );
      port( 
           clk : in STD_LOGIC;
           reset: in STD_LOGIC;

           dbg_addr:   in  STD_LOGIC_VECTOR((reg_addr_width - 1) downto 0) := (others => '0'); -- debugging regesters 
           dbg_val:    out STD_LOGIC_VECTOR((data_width - 1) downto 0) := (others => '0')     -- debugging regesters
           );
    end component;

    signal clk : STD_LOGIC;
    signal reset : STD_LOGIC;
    signal dbg_addr_tb: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal dbg_val_tb : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

begin
  
  -- Generate simulated greg clock with 10 ns period
  clkproc: process begin
    clk <= '1';
    wait for 10 ns; 
    clk <= '0';
    wait for 10 ns;
  end process;
  
  -- Generate reset for first few clock cycles
  reproc: process begin
    reset <= '1';
    wait for 22 ns;
    reset <= '0';
    wait;
  end process;
  
  -- instantiate device to be tested
   dut: greg
    generic map(
        data_width => 16,
        reg_addr_width => 4
    )
    port map(
        clk   => clk,
        reset => reset,
        dbg_addr => dbg_addr_tb, -- Connect the missing port
        dbg_val  => dbg_val_tb   -- Connect the output port
    );
  --      out_port_1 => out_port_1 

end greg_testbench;

```


## 25 pts. Section 2: Processor Input and Output


### Section 2.1 Basic Input and Output (10 pts.)
You group MUST implement ALL of the following forms of basic input/output

* 16 switches (or push buttons) 
* 16 Lights/LEDs   
* HEX display output

### Basic Input
To read the value of the switches, your hardware could either use memory mapped I/O or a special "input" instruction. 

* For memory mapped input approach, your program will use a memory read instruction (e.g. lw) to read from a specific memory address. That memory address will activate a mux which selects current value of the switches instead of a memory location. Your DPU will need to add a MUX with a control signal activated by the specific memory address you choose.  For example, if you assign memory address 63 to the switches, whenever you read from memory address 63, the mux will sense this, and rather than routing data from actual memory location 63 in your memory, it will route the switch bits and send their value to the destination register of your choice. 

* For a special input instruction, you will need to add a data input buffer register, as well as modifying the control unit to implement the instruction, When executing the instruction the control unit will signal the buffer register to store the current value of the switches on the board. Then the instruction can store the value either in a register or memory destination.  


### Basic Output
To write a value out to the LED's, your hardware can again use memory mapped I/O or a special "write port" instruction. For example, you could assign a specific memory address (let's say 62) to an output register that will store an output value, and this register could also be connected to the 16 LEDs on the board. Now, whenever you write a value to memory address 62, the mux will sense this, and rather than writing data to actual memory location 62 in your memory, it will route the value of the source register to the special externally connected 16 bit "output register" (separate from your main register file) which will hold the value steady. The LEDS which are portmapped and connected to this register will then display the last value written. 

The same approach can work for the Hex display. You are welcome to use the Hex display drivers I have provided to you already. Be sure to document where you get the code from!

Draw up the hardware design, label the signals, etc. *before* writing VHDL. After writing VHDL and getting the hardware working, then update the drawings as needed to match the actual hardware. Keep both versions so you know what you learned.

### Section 2.2: Advanced Input / Output (15 pts.)
Complete this section correctly required to recieve at least an "A-" grade or above on the final project project (the "Above and Beyond" I/O Implementation.) To prove your group can go above and beyond, your group must implement and demonstrate a more advanced form of I/O (e.g. keyboard, VGA, SPI port, etc.) that works with your processor and your machine code program.  You can interface with this more advanced I/O in many different ways, however, using the same approach to control this I/O as you did for the basic I/O will work. Your code must write output to an advanced output device and must also read input from an advanced output device.

Document precisely what forms of I/O you have implemented (both basic and advanced) that your group has working here:


```

    --*********************************************************************
    --Fig. 3 Description of I/O Devices Implemented That Work
    --*********************************************************************


    -- as of right now we only have basic IO impementaiton working. Our output is not reading from memory insted it is ableto read any of the 16 regesters by flipping the bottom 4 switches. I know that this is not the IO you directly told us to use but it does work and properly shows an output. 

    Input is curently being built and it is basic. If it works it will alow you to input a vale into the last memory slot by pressing the top button.

```

### Section 2 Notes

The connections to the LED's and Switches must happen at the top level of your FPGA project (as illustrated previously). Thus, you need to :
1. Add an output port at the top level of your processor that carries out the 16 bit signal from the memory mapped output to the external world LEDs or advanced output device.
2. Add an input port at the top level of your processor that brings in the 16 bit switch signal from the external board into the processor and connects this signal to the special memory mapped input processing hardware. 

Here are some ideas in order of relative complexity for advanced I/O:
1. Keyboard driver - This is not too bad but requires a keyboard that is compatible with PS2 keyboard signals.  
2. VGA driver - Harder because you need a VGA display but not too hard to implement in VHDL. The difficult part is a VGA display memory that the VGA driver displays.
3. External RAM interface to the ram generated by Vivado's memory generator - follow the lab given previously and then integrate your processor to read / write to the RAM.
4. SPI input/output ports that are implemented on the FPGA board.  These could connect to the SPI joystick, etc.
5. Some other I/O device that you clear with me and is compatible with our boards.

## 25 pts. Section 3: Working Demonstration Program

Design a "Demonstration Program" (e.g. a game, a demo, etc.) that shows off the capabilities of you microprocessor as well as use all of the I/O implemented for your microprocessor. 


```

    --*********************************************************************
    --Fig. 4 Your Assembly Language Program for the Final Poject
    --*********************************************************************
for now this is the code I have that works in the simmulation in vivado but not on the board. this includes input IO and output using switches. 

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


    -- Put a description of your final assembly language test program here. 
    -- Describe what works and what does not work here.
    -- Describe what file contains your assembly language test program here.

```

## 25 pts. Section 4: Final Project Presentation and Reflection

### Section 4.1 Final Presentation (15 pts.)

Your group's 15 minute final presentation will be delivered during the final exam presentations.
1.	What was your original goal? What did your group end up doing?
2.  List all the working assembly language instructions your group implemented.
3.  Demonstrate your FPGA processor actually running and interacting with your I/O (either the basic I/O from exercise 1 or the more advanced I/O from exercise 2).
4.  Present your I/O design, your Microprocessor design using professional hardware diagrarms (similar to what we have in the book). 
5.  What challenges did you face? How did you overcome them? What did you learn?

### Section 4.2 __Individual__ Final Reflection and Individual Contributions to the Project (10 pts.)
Again there will be a survey to which you will submit a confidential final reflection of your contributions to the project.
1.	What did you learn doing this project?
2.	What went well?
3.	What challenges did you face individually?
4.	How did your group function? What could have been improved? How will you avoid any issues in the future?
5.  What issues did your group face, is there anything your professor needs to know?

# Deliverables: What to Hand In
* Modify this document as described in the required sections:
    - Figure 1: Control Unit Design included in this document.
    - Figure 2: Simulation Test Bench Code included in this document.
    - Figure 3: Description of I/O Devices Implemented That Work
    - Figure 4: Your Assembly Language Program for the Final Poject
* Push all your VHDL code for your project into your group project folder FP4 along with working gen.sh/setup.tcl scripts that will create the Vivado project with a working simulation from the VHDL files/constraint/memory files in your project folder. Make sure your .gitignore file is correct!
* Put a PDF copy of  your final presentation in this folder.

## Individually Scaled Group Grades
The points for the entire project will be multiplied by scale factor for each individual in the group and will be based on the instructor's perception of each individual's contribution to the group project. This perception is built by observing your 
* Attendance, 
* Contributions and interactions while working in class, 
* Your individual commits to this repository and the quality of the content of your commits and the quality of the commit messages
* Observations of your participation in the group.
* The quality of your individual reflection.


# Evaluation Rubric
| CATEGORY |  Beginning 0%-79% | Satisfactory 80%-89% | Excellent 90%-100% |
|:--------:|:-----------------:|:--------------------:|:------------------:|
| 25 pts. 1: CU Design | Beginning CU design. Limited number of instructions without effecient use of instructions.  | Covers all operations neccessary for writing complex algorithms. Sastisfactory coverage of instructions. | Excellent control unit with 12+ instructions OR multicycle OR dual processor control unit OR other advanced processor with associated control unit. |
| 25 pts. 2: Processor I/O| Either no I/O or only one or two basic I/O implemented. | Basic I/O Implemenets | Basic + advanced I/O that works well and interfaces with an interesting demonstration program. |
| 25 pts. 3: Demonstration Program  | Simulation test bench created but not documented well  extremely basic test program |	Satisfactory simulation + test code algorithm that demonstrated all instructions. |	Simulation works plus an advanced program that runs correctly and interfaces with advanced I/O. |
| 15 pts. 4: Final Project Presentation | Little to no content, poor presentation, did not address required elements. | Several of the required elements for presentation | All the required elements for the presentation and a good presentation with demonstration of running processor / program |
| 10 pts. 4.2: Individual Reflection | Little to no reflection or learning described. | Some of the required elements of the reflection. Some refllection. | All the required reflection questions answered well, demonstrates excellent learning outcomes. |





