--------------------------------------------------------------------------------
--  Module Name:  sim_adder 
--      Purpose:  Example of a programmed test bench
--------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;        -- use this instead of STD_LOGIC_ARITH

entity sim_adder is
    GENERIC( N_SIM : integer range 1 to 14 := 8 );          
end sim_adder;

architecture Behavioral of sim_adder is

component adder is
    generic(data_width : integer);
Port (   a : in  STD_LOGIC_VECTOR(data_width-1 downto 0);
         b : in  STD_LOGIC_VECTOR(1 downto 0);
         y  : out STD_LOGIC_VECTOR(data_width-1 downto 0)
    );
end component;
              
-- signal wires for each output of our mux2 module
signal sim_a : STD_LOGIC_VECTOR((N_SIM-1) downto 0);
signal sim_b : STD_LOGIC_VECTOR(1 downto 0);
signal sim_y : STD_LOGIC_VECTOR((N_SIM-1) downto 0);

begin
sim_unit : adder
    generic map(data_width => N_SIM)
    port map(   a => sim_a, 
                b => sim_b,
                y => sim_y
    );

process 
begin

    sim_a <= (others => '0'); sim_b <= (others => '1'); wait for 10 ns;
    assert unsigned(sim_y) = unsigned(sim_a) + resize(unsigned(sim_b), N_SIM) report "failed for first case";

    sim_a <= (others => '1'); sim_b <= (others => '1'); wait for 10 ns;
    assert unsigned(sim_y) = unsigned(sim_a) + resize(unsigned(sim_b), N_SIM) report "failed for second case";

    sim_a <= (others => '1'); sim_b <= (others => '0'); wait for 10 ns;
    assert unsigned(sim_y) = unsigned(sim_a) + resize(unsigned(sim_b), N_SIM) report "failed for third case";

    sim_a <= (others => '0'); sim_b <= (others => '0'); wait for 10 ns;
    assert unsigned(sim_y) = unsigned(sim_a) + resize(unsigned(sim_b), N_SIM) report "failed for last case";

    wait; -- stop the simulation process after one cycle
 end process;

end Behavioral;
