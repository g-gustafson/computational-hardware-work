------------------------------------------------------------------------------
-- Instruction Memory
------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD.all;

entity instrmem is -- instruction memory entity
  generic(data_width: integer;
          reg_addr_width: integer
    );
  port(
    cur_pc:                   in  STD_LOGIC_VECTOR((data_width - 1) downto 0);
    op_code:                  out STD_LOGIC_VECTOR(3 downto 0);
    y_addr, a_addr, b_addr:   out STD_LOGIC_VECTOR((reg_addr_width - 1) downto 0);
    imm_val, pc_next_addr:    out STD_LOGIC_VECTOR((data_width - 1) downto 0)
    );
  end instrmem;


architecture behave of instrmem is
  type ramtype is array (4095 downto 0) of STD_LOGIC_VECTOR((8 - 1) downto 0); -- the math allows for the max amount of possible address combinations

  -- function to initialize the instruction memory from a data file
    -- it loops though the data file that is created by the assembler
    -- this funciton is basicly just converting it into binary form hex
  impure function InitRamFromFile (RamFileName : in string ) return RamType is

--TODO: the stuff below this comment is form mips examples. the stuff above has been altered already
    -- please continue making changes so it works for our processor

  variable ch: character;
  variable index : integer;
  variable result: signed((8-1) downto 0);
  variable tmpResult: signed(63 downto 0);
  file mem_file: TEXT is in RamFileName;
  variable L: line;
  variable val: integer;
  variable RAM : ramtype;
  begin
    -- initialize memory from a file
    for i in 0 to (4095) loop -- set all contents low -- also might have error for decending loop
      RAM(i) := std_logic_vector(to_unsigned(0, 8));
    end loop;
    index := 0;
    while not endfile(mem_file) loop
      -- read the next line from the file
      readline(mem_file, L);
      result := to_signed(0,8);
      for i in 1 to 2 loop
        -- read character from the line just read
        read(L, ch);
        --  convert character to a binary value from a hex value
        if '0' <= ch and ch <= '9' then
          val := character'pos(ch) - character'pos('0');
        elsif 'a' <= ch and ch <= 'f' then
          val := character'pos(ch) - character'pos('a') + 10;
        elsif 'A' <= ch and ch <= 'F' then
          val := character'pos(ch) - character'pos('A') + 10;
        else report "Format error on line " & integer'image(index)
          severity error;
        end if;
        result := shift_left(result, 4) + to_signed(val, 8);
      end loop;

      -- set the width bit binary value in ram
      RAM(index) := std_logic_vector(result);
      index := index + 1;
    end loop;
    -- return the array of instructions loaded in RAM
    return RAM;
  end function;

  -- use the impure function to read RAM from a file and store in the FPGA's ram memory
  signal mem: ramtype := InitRamFromFile("memfile.dat");

begin
  process ( all ) is
  begin -- we always output 3 bits worth of data spread accross the different outputs
    op_code                      <= mem(to_integer(unsigned(cur_pc)))(7 downto 4); -- always first 4 bits 0:3
    y_addr                       <= mem(to_integer(unsigned(cur_pc)))(3 downto 0); -- always second 4 bits 3:7
    a_addr                       <= mem(to_integer(unsigned(cur_pc)) + 1)(7 downto 4); -- always third 4 bits 8:11
    b_addr                       <= mem(to_integer(unsigned(cur_pc)) + 1)(3 downto 0); -- always forth 4 bits 12:15
    imm_val(15 downto 8)         <= mem(to_integer(unsigned(cur_pc)) + 1)(7 downto 0); -- 8:15
    imm_val(7 downto 0)          <= mem(to_integer(unsigned(cur_pc)) + 2)(7 downto 0); -- 16:24
    pc_next_addr(15 downto 8)    <= mem(to_integer(unsigned(cur_pc)) + 1)(7 downto 0); -- 8:15
    pc_next_addr(7 downto 0)     <= mem(to_integer(unsigned(cur_pc)) + 2)(7 downto 0); -- 15:24
  end process;
end behave;
