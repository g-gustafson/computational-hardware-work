library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;

entity alu is -- greg's alu :() input and output signals
    generic(data_width: integer);
    port(clk, reset: in  STD_LOGIC;
         alu_ctrl:   in  STD_LOGIC_VECTOR(2 downto 0);
         flag_sel:   in  STD_LOGIC_VECTOR(1 downto 0);
         a:          in  STD_LOGIC_VECTOR((data_width - 1) downto 0);
         b:          in  STD_LOGIC_VECTOR((data_width - 1) downto 0);
         y:          out STD_LOGIC_VECTOR((data_width - 1) downto 0);
         flag:       out STD_LOGIC -- outputting a flag to be checked to see if we branch in the and gate
    );
end alu;

architecture behave of alu is 
    signal reg_zero:       STD_LOGIC := '0';
    signal reg_negative:   STD_LOGIC := '0';
    signal next_zero        : STD_LOGIC;
    signal next_negative    : STD_LOGIC;
begin

    process(all)
        -- defining variables that represent values after mid alu mux
        variable b_prime     : STD_LOGIC_VECTOR((data_width - 1) downto 0);
        variable bitwise     : STD_LOGIC_VECTOR((data_width - 1) downto 0);
        variable arithmetic  : STD_LOGIC_VECTOR((data_width - 1) downto 0);
        variable associative : STD_LOGIC_VECTOR((data_width - 1) downto 0);
        variable result      : STD_LOGIC_VECTOR((data_width - 1) downto 0);
    begin

        -- logic for urnary not                                          (b_prime)
        -- logic for and/or mux before multiplexer                       (bitwise)
        -- Logic for add/sub                                             (arithmetic)
        -- logic for shift and rotate mux before multiplexer at the end  (associative)
        if alu_ctrl(2) = '0' then
            b_prime     := b;
            bitwise     := (a and b);
            arithmetic  := std_logic_vector(unsigned(a) + unsigned(b));
            associative := std_logic_vector(shift_right(unsigned(a),  to_integer(unsigned(b))));
        else
            b_prime     := (not b);
            bitwise     := (a or b);
            arithmetic  := std_logic_vector(unsigned(a) + unsigned(not b) + to_unsigned(1, data_width));
            associative := std_logic_vector(rotate_right(unsigned(a), to_integer(unsigned(b))));
        end if;

        case alu_ctrl(1 downto 0) is
            when "00"   => result := b_prime;
            when "01"   => result := bitwise;
            when "10"   => result := arithmetic;
            when "11"   => result := associative;
            when others => result := (others => '0');
        end case;

        -- Calculating the flag values
        -- Negative flag: Check the MSB (Most Significant Bit)
        next_negative <= result(data_width - 1);

        -- Zero flag: Check if all bits are '0'
        if unsigned(result) = 0 then 
            next_zero <= '1'; 
        else 
            next_zero <= '0'; 
        end if;

        y <= result;
    end process;

process(clk) 
  begin 
    if rising_edge(clk) then 
      if reset = '1' then
        reg_zero     <= '0';
        reg_negative <= '0';
      elsif alu_ctrl /= "000" then 
        reg_zero     <= next_zero; 
        reg_negative <= next_negative; 
      end if; 
    end if; 
  end process;


    -- flag output mux
    -- Use flag_sel to choose which flag in register to output to the branch gate
    process(flag_sel, reg_zero, reg_negative)
    begin
        case flag_sel is
            when "00"   => flag <= reg_zero;         --  (Branch if Equal/Zero)
            when "01"   => flag <= not reg_zero;     --  (Branch Not Equal)
            when "10"   => flag <= reg_negative;     --  (Branch Less Than)
            when "11"   => flag <= not reg_negative; --  (Branch greater then)
            when others => flag <= '0';
        end case;
    end process;

end behave;