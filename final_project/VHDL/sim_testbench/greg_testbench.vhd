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
    wait for 25 ns; 
    clk <= '0';
    wait for 25 ns;
  end process;
  
  -- Generate reset for first few clock cycles
  reproc: process begin
    reset <= '1';
    wait for 55 ns;
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