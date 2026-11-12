library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;

entity regfile is 
  generic(data_width: integer; reg_addr_width: integer);
  port(clk, reset:             in  STD_LOGIC;
       imm_w:                  in  STD_LOGIC;
       do_branch:              in  STD_LOGIC;
       a_addr, b_addr, y_addr: in  STD_LOGIC_VECTOR((reg_addr_width-1) downto 0);
       write_val:              in  STD_LOGIC_VECTOR((data_width-1) downto 0);
       imm_val:                in  STD_LOGIC_VECTOR((data_width-1) downto 0);
       return_pc:              in  STD_LOGIC_VECTOR((data_width-1) downto 0);
       dbg_addr:               in  STD_LOGIC_VECTOR((reg_addr_width-1) downto 0); --debug signal 
       a_val, b_val:           out STD_LOGIC_VECTOR((data_width-1) downto 0);
       dbg_val:                out STD_LOGIC_VECTOR((data_width-1) downto 0) -- debug signal
  );
end;


architecture behave of regfile is
  -- Define ramtype
  type ramtype is array ((data_width-1) downto 0) of STD_LOGIC_VECTOR((data_width-1) downto 0);
  -- Define signal mem of type ramtype
  signal mem: ramtype := (others => (others => '0'));

  signal inv_clk : STD_LOGIC; -- for inverse clk to have it write on the falling edge 
  signal y_addr_reg: STD_LOGIC_VECTOR((reg_addr_width-1) downto 0); -- this keeps the y address signal around long enough to be used later
begin


  inv_clk <= not clk; -- inverting the system clock so we write on the falling edge of the clock insted

process(clk)
begin
    if rising_edge(clk) then
        -- Grab the address at the start of the cycle and freeze it
        y_addr_reg <=  y_addr; 
    end if;
end process;

-- On falling edge of clock write immediate value to 3rd port 
-- Write address is in y_addr
  process(inv_clk) begin -- we want this to happen when the clk happens or when we get an updated write_val
    if rising_edge(inv_clk) then
      if ( to_integer(unsigned(y_addr)) /= 0 ) then
		    if imm_w = '1' then 
			      mem(to_integer(unsigned(y_addr))) <= imm_val;
		    
        elsif do_branch = '1' then
            mem(to_integer(unsigned(y_addr))) <= return_pc; 
        end if;
      end if;
      if (to_integer(unsigned(y_addr_reg)) /= 0) and (unsigned(write_val) /= 0) then
          mem(to_integer(unsigned(y_addr_reg))) <= write_val;
      end if;
        
      
    end if;
  end process;
            


  process(a_addr, b_addr, mem) begin
    if ( to_integer(unsigned(a_addr)) = 0) then 
		  a_val <= (others => '0'); -- register 0 holds 0
    else 
		  a_val <= mem(to_integer(unsigned(a_addr)));
    end if;
	
    if ( to_integer(unsigned(b_addr)) = 0) then 
		  b_val <= (others => '0'); -- register 0 holds 0
    else 
		  b_val <= mem(to_integer( unsigned(b_addr)));
    end if;
  end process;
  
  dbg_val <= mem(to_integer(unsigned(dbg_addr))); -- used to switch between the regesters


end;
