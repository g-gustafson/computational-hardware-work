--------------------------------------------------------------------------------
--  Module Name:  sim_flopr 
--      Purpose:  Example of a programmed test bench
--------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;        -- use this instead of STD_LOGIC_ARITH

entity sim_flopr is
    GENERIC( N_SIM : integer range 1 to 14 := 8 );          
end sim_flopr;

architecture Behavioral of sim_flopr is
    constant BITS_TO_SIM : integer := 2*N_SIM + 3;

component flopr is
    generic(data_width : integer);
Port (  clk   : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        d     : in  STD_LOGIC_VECTOR(data_width-1 downto 0);
        q     : out STD_LOGIC_VECTOR(data_width-1 downto 0)
    );
end component;
              
-- signal wires for each output of our flopr module
signal sim_clk   : STD_LOGIC;
signal sim_reset : STD_LOGIC;
signal sim_d     : STD_LOGIC_VECTOR((N_SIM-1) downto 0);
signal sim_q     : STD_LOGIC_VECTOR((N_SIM-1) downto 0);

begin
sim_unit : flopr
    generic map(data_width => N_SIM)
    port map(   clk   => sim_clk,
                reset => sim_reset,
                d     => sim_d,
                q     => sim_q
    );

    -- clock generation
clk_process : process
begin
    loop
        sim_clk <= '0';
        wait for 5 ns;

        sim_clk <= '1';
        wait for 5 ns;
    end loop;
end process;

stim_process: process
begin
    -- test reset
    sim_reset <= '1'; sim_d <= (others => '1');
    assert sim_q = (sim_q'range => '0') report "reset failed";
    -- release reset
    sim_reset <= '0';

    -- test loading zeros
    sim_d <= (others => '0'); wait for 10 ns;
    assert sim_q = sim_d report "load zero failed"

    -- test loading ones
    sim_d <= (others => '1'); wait for 10 ns;
    assert sim_q = sim_d report "load one failed"

    report "TEST DONE";

    wait;
    end process;

end Behavioral;








