--------------------------------------------------------------------------------
--  Module Name:  sim_ander 
--      Purpose:  Example of a programmed test bench
--------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sim_ander is         
end sim_ander;

architecture Behavioral of sim_ander is

component ander is
Port (   a : in  STD_LOGIC;
         b : in  STD_LOGIC;
         y : out STD_LOGIC
    );
end component;
              
-- signal wires for each output of our mux2 module
signal sim_a : STD_LOGIC;
signal sim_b : STD_LOGIC;
signal sim_y : STD_LOGIC;

begin
sim_unit : ander
    port map(   a => sim_a, 
                b => sim_b,
                y => sim_y
    );

process 
begin

    sim_a <= '0'; sim_b <= '0'; wait for 10 ns;
    assert sim_y = sim_a and sim_b report "failed for first case";

    sim_a <= '0'; sim_b <= '1'; wait for 10 ns;
    assert sim_y = sim_a and sim_b report "failed for second case";

    sim_a <= '1'; sim_b <= '0'; wait for 10 ns;
    assert sim_y = sim_a and sim_b report "failed for third case";

    sim_a <= '1'; sim_b <= '1'; wait for 10 ns;
    assert sim_y = sim_a and sim_b report "failed for last case";

    wait; -- stop the simulation process after one cycle
 end process;

end Behavioral;
