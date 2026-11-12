library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity greg_testbench is
end;

architecture behave of greg_testbench is
    -- 1. Changed component to target your true top-level module
    component greg_top is
        generic(
            data_width: integer := 16;
            reg_addr_width: integer := 4
        );
        port(
            CLK100MHZ : in STD_LOGIC;
            btnC      : in STD_LOGIC;
            btnU      : in STD_LOGIC;
            sw        : in STD_LOGIC_VECTOR(15 downto 0);
            LED       : out STD_LOGIC_VECTOR(15 downto 0);
            seg       : out STD_LOGIC_VECTOR(6 downto 0);
            an        : out STD_LOGIC_VECTOR(3 downto 0);
            dp        : out STD_LOGIC
        );
    end component;

    -- Local Simulation Signals
    signal clk_tb   : STD_LOGIC;
    signal reset_tb : STD_LOGIC;
    signal btnU_tb  : STD_LOGIC := '0';
    signal sw_tb    : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal led_tb   : STD_LOGIC_VECTOR(15 downto 0);
    
    -- Unused board outputs (can be left open or tied to dummy signals)
    signal seg_dummy : STD_LOGIC_VECTOR(6 downto 0);
    signal an_dummy  : STD_LOGIC_VECTOR(3 downto 0);
    signal dp_dummy  : STD_LOGIC;

begin

    -- Generate simulated 100MHz clock (10 ns total period)
    clkproc: process
    begin
        clk_tb <= '1';
        wait for 25 ns;
        clk_tb <= '0';
        wait for 25 ns;
    end process;

    -- Generate initial system reset
    reproc: process
    begin
        reset_tb <= '1';
        wait for 55 ns;
        reset_tb <= '0';
        wait;
    end process;

    -- 2. Device Under Test (DUT) Instantiation pointing to the Top-Level
    dut: greg_top
        generic map(
            data_width => 16,
            reg_addr_width => 4
        )
        port map(
            CLK100MHZ => clk_tb,
            btnC      => reset_tb,
            btnU      => btnU_tb,
            sw        => sw_tb,
            LED       => led_tb,
            seg       => seg_dummy,
            an        => an_dummy,
            dp        => dp_dummy
        );

    -- 3. Stimulus Process explicitly handling the IO Mapping Actions
    io_stimulus_proc: process
    begin
        -- Hold everything clean during the active reset phase
        btnU_tb <= '0';
        sw_tb   <= x"0000";
        wait for 60 ns; 
        
        -- Let the processor run an initial instruction lifecycle 
        wait for 80 ns;

        -- TEST CASE 1: Load a pattern on switches and trigger an IO Write
        wait until falling_edge(clk_tb);
        sw_tb <= x"ABCD"; -- Data value to capture into memory address 0x0FFF
        
        wait until falling_edge(clk_tb);
        btnU_tb <= '1';   -- Assert button HIGH to create a rising edge inside datamem
        
        wait until falling_edge(clk_tb);
        btnU_tb <= '0';   -- Pull button LOW (satisfies: btn_write = '1' and btn_prev = '0')
        
        -- TEST CASE 2: Change switches to test that it does NOT overwrite without another button press
        wait for 40 ns;
        wait until falling_edge(clk_tb);
        sw_tb <= x"FFFF"; -- Change switch data
        
        -- Wait a few clock cycles to observe internal CPU state change
        wait for 150 ns;
        
        -- End Simulation
        wait;
    end process;

end behave;
