--------------------------------------------------------------------------------
--  Module Name:  sim_mux2 
--      Purpose:  Example of a programmed test bench
--------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sim_mux2 is
    GENERIC( N_SIM : integer range 1 to 14 := 8 );          
end sim_mux2;

architecture Behavioral of sim_mux2 is

component mux2 is
    generic(data_width : integer);
Port (   d0 : in  STD_LOGIC_VECTOR(data_width-1 downto 0);
         d1 : in  STD_LOGIC_VECTOR(data_width-1 downto 0);
         s  : in  STD_LOGIC;
         y  : out STD_LOGIC_VECTOR(data_width-1 downto 0)
    );
end component;
              
-- signal wires for each output of our mux2 module
signal sim_a : STD_LOGIC_VECTOR((N_SIM-1) downto 0);
signal sim_b : STD_LOGIC_VECTOR((N_SIM-1) downto 0);
signal sim_s : STD_LOGIC;
signal sim_y : STD_LOGIC_VECTOR((N_SIM-1) downto 0);

begin
-- Let's make a mux2 hardware object and connect its inputs to our simulation signals
sim_unit : mux2 
    generic map(data_width => N_SIM)
    port map(   d0 => sim_a, 
                d1 => sim_b,
                s => sim_s,
                y => sim_y
    );

process begin

    sim_a <= (others => '0'); sim_b <= (others => '1'); sim_s <= '0'; wait for 10 ns;
    assert sim_y = sim_a report "failed for first case";

    sim_a <= (others => '0'); sim_b <= (others => '1'); sim_s <= '1'; wait for 10 ns;
    assert sim_y = sim_b report "failed for second case";

    sim_a <= (others => '1'); sim_b <= (others => '0'); sim_s <= '0'; wait for 10 ns;
    assert sim_y = sim_a report "failed for third case";

    sim_a <= (others => '1'); sim_b <= (others => '0'); sim_s <= '1'; wait for 10 ns;
    assert sim_y = sim_b report "failed for last case";

    wait; -- stop the simulation process after one cycle
 end process;

end Behavioral;
