--------------------------------------------------------------------------------
--  Module Name:  sim_alu 
--      Purpose:  Example of a programmed test bench 
-- Project Name:  Test all inputs for the N bit alu (has two N bit inputs)
--------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;        -- use this instead of STD_LOGIC_ARITH
 
ENTITY sim_alu IS
  GENERIC( N_SIM : integer range 1 to 14 := 8 );
END sim_alu;
 
ARCHITECTURE behavioral OF sim_alu IS 

  -- Bits we want to simulate based on bits per input (N_SIM)
  constant BITS_TO_SIM : integer := 2*N_SIM + 3;

  -- These signals are use to wire the alu to the board level signals
  -- input signals
  signal clk_sim          : STD_LOGIC;
  signal alu_sim          : STD_LOGIC_VECTOR( 2 downto 0);
  signal flag_sel_sim     : STD_LOGIC_VECTOR( 1 downto 0);
  signal a_sim, b_sim     : STD_LOGIC_VECTOR( (N_SIM-1) downto 0 );
  signal y_sim            : STD_LOGIC_VECTOR( (N_SIM-1) downto 0 );
  
  -- output signal
  signal flag_sim         : STD_LOGIC;
  signal reg_zero_sim     : STD_LOGIC := '0';
  signal reg_negative_sim : STD_LOGIC := '0';

  ----------------------------------------------------------------------------------------
  -- Function to_string for testbench
  -- convert a STD Logic vector to a string so we can report it in the testbench console
  -- output.
  -- source: https://stackoverflow.com/questions/15406887/vhdl-convert-vector-to-string
  -----------------------------------------------------------------------------------------
  function to_string ( a: STD_LOGIC_VECTOR) return string is
    variable b : string (1 to a'length) := (others => NUL);
    variable stri : integer := 1; 
    begin
        for i in a'range loop
            b(stri) := std_logic'image(a((i)))(2);
        stri := stri+1;
        end loop;
    return b;
  end function;

BEGIN
  -- clock generation
  clk_process : process
    begin
    loop
        clk_sim <= '0';
        wait for 5 ns;

        clk_sim <= '1';
        wait for 5 ns;
    end loop;
  end process;

    -- ALU we will test against
    sim_unit : entity work.greg_alu
      generic map (
        N => N_SIM
      )
      port map ( 
        clk      => clk_sim,
        a        => a_sim, 
        b        => b_sim,
        flag_sel => flag_sel_sim,
        alu_sim  => alu_sim,
        y        => y_sim,
        flag     => flag_sim
      );

  stim_proc: process
      variable i: integer range 0 to (2 ** BITS_TO_SIM) - 1; 
      variable b_prime, bitwise, arithmetic, associative, result: STD_LOGIC_VECTOR(N_SIM-1 downto 0);
      variable abc : std_logic_vector(BITS_TO_SIM-1 downto 0);
      variable next_zero, next_negative : STD_LOGIC;
   begin
      report "STARTING TEST";	 
      for i in 0 to (2 ** BITS_TO_SIM) - 1 loop

        -- Convert i to 35 bit std logic vector and connect signal to abc
        -- Connect bits 0,1,2 of abc to the alu_sim
        -- Connect bits 3 to N_SIM+2 of abc to b_sim
        -- Connect bits N_SIM+2 to (2*N_SIM)+2 of abc to a_sim
        abc            := STD_LOGIC_VECTOR(to_unsigned(i, BITS_TO_SIM));
        alu_sim        <= abc(2 downto 0);
        b_sim          <= abc( N_SIM+2 downto 3 );
        a_sim          <= abc( (2*N_SIM)+2 downto N_SIM+3 );

        wait for 10 ns;

        -- logic for unary not                                          (b_prime)
        -- logic for and/or mux before multiplexer                       (bitwise)
        -- Logic for add/sub                                             (arithmetic)
        -- logic for shift and rotate mux before multiplexer at the end  (associative)
        if (alu_sim(2) = '0' ) then
          b_prime     := b_sim;
          bitwise     := a_sim and b_sim;
          arithmetic  := STD_LOGIC_VECTOR(unsigned(a_sim) + unsigned(b_sim));
          associative := STD_LOGIC_VECTOR(shift_left(unsigned(a_sim),  to_integer(unsigned(b_sim)) mod N_SIM));
        else 
          b_prime     := (not b_sim);
          bitwise     := (a_sim or b_sim);
          arithmetic  := STD_LOGIC_VECTOR(unsigned(a_sim) + unsigned(not b_sim) + 1);
          associative := STD_LOGIC_VECTOR(rotate_left(unsigned(a_sim), to_integer(unsigned(b_sim)) mod N_SIM));
        end if;


        -- Test the alu stuff
        case alu_sim(1 downto 0) is
          when "00"   => result := b_prime; next_negative := result(N_SIM - 1); 
          assert y_sim = result report "Failed unary not test";

          when "01"   => result := bitwise; next_negative := result(N_SIM - 1); 
          assert y_sim = result report "Failed bitwise test";

          when "10"   => result := arithmetic; next_negative := result(N_SIM - 1); 
          assert y_sim = result report "Failed arithmetic";

          when others => result := associative; next_negative := result(N_SIM - 1); 
          assert y_sim = result report "Failed associative";
        end case;

        -- Zero flag: Check if all bits are '0'

        if unsigned(result) = 0 then 
          next_zero := '1'; 
        else 
          next_zero := '0'; 
        end if;
        
        -- Set zero register and negative register to the next zero and next negative
        reg_zero_sim     <= next_zero;
        reg_negative_sim <= next_negative;
        wait for 10 ns;

        -- flag output mux
        -- Use flag_sel to choose which flag in register to output to the branch gate
        
        flag_sel_sim <= "00"; wait for 10 ns;
        assert flag_sim = reg_zero_sim report "failed for first case"; --  (Branch if Equal/Zero)
        
        flag_sel_sim <= "01"; wait for 10 ns;
        assert flag_sim = not reg_zero_sim report "failed for second case"; --  (Branch Not Equal)
        
        flag_sel_sim <= "10"; wait for 10 ns;
        assert flag_sim = reg_negative_sim report "failed for third case"; --  (Branch Less Than)

        flag_sel_sim <= "11"; wait for 10 ns;
        assert flag_sim = not reg_negative_sim report "failed for first case"; --  (Branch greater then)

      end loop;
      report "DONE";
   end process;
END behavioral;
