------------------------------------------------------------
-- greg.vhd
-- Single Cycle greg processor
------------------------------------------------------------

library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity greg_top is
 -- single cycle greg processor
  generic(
    data_width: integer := 16;
    reg_addr_width: integer := 4);
  port(
    CLK100MHZ:   in  STD_LOGIC;
    btnC:        in  STD_LOGIC;  -- center button = reset
    btnU:        in  STD_LOGIC;  -- button for io input
    sw:          in  STD_LOGIC_VECTOR(15 downto 0);
    LED:         out STD_LOGIC_VECTOR(15 downto 0); -- change this to 15
    seg:         out STD_LOGIC_VECTOR(6 downto 0);
    an:          out STD_LOGIC_VECTOR(3 downto 0);
    dp:          out STD_LOGIC
    );
end;

architecture struct of greg_top is

  component greg
    generic(
        data_width: integer;
        reg_addr_width: integer
        );
    port(
        clk, reset: in STD_LOGIC;

        sw:                      in STD_LOGIC_VECTOR((data_width-1) downto 0); -- for io input mapping 
        btn_write:               in STD_LOGIC;  -- for io input mapping 
        

        dbg_addr : in  STD_LOGIC_VECTOR((reg_addr_width - 1) downto 0); -- debugging IO
        dbg_val  : out STD_LOGIC_VECTOR((data_width - 1) downto 0)      -- debugging IO
    );
  end component;
  
  signal dbg_val_sig:  STD_LOGIC_VECTOR(15 downto 0);

  --articial clock 
  signal clk_counter:  unsigned(23 downto 0) := (others => '0');
  signal slow_clk:     std_logic := '0';

  -- DEBOUNCER SIGNALS: 3-stage shift register to sample and stabilize btnU
  signal btnU_sync  : std_logic_vector(2 downto 0) := (others => '0');
  signal btnU_clean : std_logic := '0';

begin

  -- this allows for the clock to be articialy slowed down so the procces around write val can work

  process(CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
            clk_counter <= clk_counter + 1;
            slow_clk    <= clk_counter(2); 
        end if;
    end process;

  process(slow_clk)
    begin
        if rising_edge(slow_clk) then
            -- Shift the button input value down the pipeline chain
            btnU_sync <= btnU_sync(1 downto 0) & btnU;
            
            -- Majority voting filter logic: Only assert high if button sits firmly stable
            if btnU_sync = "111" then
                btnU_clean <= '1';
            elsif btnU_sync = "000" then
                btnU_clean <= '0';
            end if;
        end if;
    end process;
    
  -- Temporary: tie outputs to something visible
  LED <= dbg_val_sig(15 downto 0); -- make 15
  seg <= (others => '1');
  an  <= (others => '1');
  dp  <= '1';

  greg_unit: greg generic map(
                    data_width,
                    reg_addr_width)
                  port map(
                    clk       => slow_clk,
                    reset     => btnC,
                    sw        => sw,
                    btn_write => btnU_clean,
                    dbg_addr  => sw(3 downto 0),
                    dbg_val   => dbg_val_sig
                  );
end;
