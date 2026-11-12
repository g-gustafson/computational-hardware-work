library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD.all;

entity datamem is -- data memory
  generic(data_width: integer);
  port(
       clk, reset, data_w:      in  STD_LOGIC;
       cur_pc:                  in  STD_LOGIC_VECTOR((data_width-1) downto 0);
       dm_addr, store_val:      in  STD_LOGIC_VECTOR((data_width-1) downto 0);

       sw:                      in STD_LOGIC_VECTOR((data_width-1) downto 0); -- for io input mapping 
       btn_write:               in STD_LOGIC;                                 -- for Io input mapping


       dmem_out:                out STD_LOGIC_VECTOR((data_width-1) downto 0)
       );
end;

architecture behave of datamem is
  type ramtype is array (255  downto 0) of STD_LOGIC_VECTOR((data_width-1) downto 0); 
  signal mem: ramtype := (others => (others => '0'));

  constant SW_ADDR : STD_LOGIC_VECTOR(15 downto 0) := x"00FF"; -- of io mapping memory locaton
  signal btn_prev : STD_LOGIC := '0'; -- for io input 

begin
  process (clk) is
  begin
    if rising_edge(clk) then
      if (data_w = '1') then
	      mem( to_integer(unsigned(dm_addr((data_width-1) downto 0))) ) <= store_val; 

        elsif btn_write = '1' and btn_prev = '0' then
          mem(to_integer(unsigned(SW_ADDR(15 downto 0)))) <= sw;
        end if;
    
      if reset = '1' then
        dmem_out <= (others => '0');
       else
        dmem_out <= mem(to_integer(unsigned(dm_addr(8-1 downto 0))));
      end if;
     btn_prev <= btn_write;
    end if;

  end process;

end;
