------------------------------------------------------------
-- greg.vhd
-- Single Cycle greg processor
------------------------------------------------------------

------------------------------------------------------------
-- Entity Declarations
------------------------------------------------------------

library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity greg is
 -- single cycle greg processor
  generic(
    data_width: integer;
    reg_addr_width: integer);
  port(
    clk, reset: in STD_LOGIC;

    sw:         in STD_LOGIC_VECTOR((data_width-1) downto 0); -- for io input mapping 
    btn_write:  in STD_LOGIC;   -- for io input mapping

    dbg_addr:   in  STD_LOGIC_VECTOR((reg_addr_width - 1) downto 0) := (others => '0'); -- debugging regesters 
    dbg_val:    out STD_LOGIC_VECTOR((data_width - 1) downto 0) := (others => '0')      -- debugging regesters
  );
end;

architecture struct of greg is

---------------------------------------------------------
-- Component Definitions
---------------------------------------------------------

  component controller
    port(
       op_code:            in  STD_LOGIC_VECTOR(3 downto 0);
       alu_ctrl:           out STD_LOGIC_VECTOR(2 downto 0);
       flag_sel:           out STD_LOGIC_VECTOR(1 downto 0);
       data_w:             out STD_LOGIC;
       imm_w:              out STD_LOGIC;
       reg_w_src:          out STD_LOGIC;
       do_branch:          out STD_LOGIC;
       do_jump:            out STD_LOGIC;
       instr_len:          out STD_LOGIC_VECTOR(1 downto 0)
       );
  end component;
  
  component datapath
    generic(
      data_width: integer;
      reg_addr_width: integer);
    port(
      clk, reset:     in  STD_LOGIC;

      a_addr, b_addr: in  STD_LOGIC_VECTOR((reg_addr_width - 1) downto 0);
      imm_val:        in  STD_LOGIC_VECTOR((data_width - 1) downto 0);
      y_addr:         in  STD_LOGIC_VECTOR((reg_addr_width - 1) downto 0);
      pc_next_addr:   in  STD_LOGIC_VECTOR((data_width - 1) downto 0);
      
      alu_ctrl:       in STD_LOGIC_VECTOR(2 downto 0);
      flag_sel:       in STD_LOGIC_VECTOR(1 downto 0);
      imm_w:          in STD_LOGIC;
      reg_w_src:      in STD_LOGIC;
      do_branch:      in STD_LOGIC;
      instr_len:      in STD_LOGIC_VECTOR(1 downto 0); -- different size because it is amout we incriment program counter by so max of 24
      do_jump:        in STD_LOGIC;
      
      dmem_out:       in STD_LOGIC_VECTOR((data_width-1) downto 0); -- output form data memory
      
      dm_addr:        out STD_LOGIC_VECTOR((data_width - 1) downto 0);
      store_val:      out STD_LOGIC_VECTOR((data_width - 1) downto 0);
      cur_pc:         out STD_LOGIC_VECTOR((data_width - 1) downto 0);

      dbg_addr:       in  STD_LOGIC_VECTOR((reg_addr_width - 1) downto 0); -- debugging regesters 
      dbg_val:        out STD_LOGIC_VECTOR((data_width - 1) downto 0)     -- debugging regesters
       );
  end component;

  component datamem
    generic(
      data_width: integer);
    port(
      clk, reset, data_w:      in STD_LOGIC;
      cur_pc:                  in  STD_LOGIC_VECTOR((data_width-1) downto 0);
      dm_addr, store_val:      in STD_LOGIC_VECTOR((data_width-1) downto 0);

      sw:                      in STD_LOGIC_VECTOR((data_width-1) downto 0); -- for io input mapping 
      btn_write:               in STD_LOGIC;  -- for io input mapping

      dmem_out:                out STD_LOGIC_VECTOR((data_width-1) downto 0)
    );
  end component;

  component instrmem
    generic(
      data_width: integer;
      reg_addr_width: integer);
    port(
      cur_pc:                   in  STD_LOGIC_VECTOR((data_width - 1) downto 0);
      op_code:                  out STD_LOGIC_VECTOR(3 downto 0);
      y_addr, a_addr, b_addr:   out STD_LOGIC_VECTOR((reg_addr_width - 1) downto 0);
      imm_val, pc_next_addr:    out STD_LOGIC_VECTOR((data_width - 1) downto 0)
      );
  end component;

  
-- everyting below this line is not done 
---------------------------------------------------------
  
  -- Signals to wire the components together

  signal data_w_sig, imm_w_sig, reg_w_src_sig, do_branch_sig: STD_LOGIC;     -- signals for the control unit to others
  signal flag_sel_sig, instr_len_sig: STD_LOGIC_VECTOR(1 downto 0);          -- signals for the control unit to others
  signal alu_ctrl_sig:                     STD_LOGIC_VECTOR(2 downto 0);          -- signals for the control unit to others
  signal op_code_sig:                 STD_LOGIC_VECTOR(3 downto 0);          -- signals for the control unit to others
  signal do_jump_sig:                 STD_LOGIC;

  signal dmem_out_sig:                           STD_LOGIC_VECTOR((data_width-1) downto 0);  -- connects data path and mem data
  signal imm_val_sig, pc_next_addr_sig:          STD_LOGIC_VECTOR((data_width-1) downto 0);  -- connects intra mem and data path
  signal a_addr_sig, b_addr_sig, y_addr_sig:     STD_LOGIC_VECTOR((reg_addr_width - 1) downto 0); -- connects intra mem and data path
  signal dm_addr_sig, store_val_sig, cur_pc_sig: STD_LOGIC_VECTOR((data_width-1) downto 0); -- connects outputs from data path with other

begin
  control_unit: controller  port map(
                              op_code      => op_code_sig,
                              alu_ctrl     => alu_ctrl_sig,
                              flag_sel     => flag_sel_sig,
                              data_w       => data_w_sig,
                              imm_w        => imm_w_sig,
                              reg_w_src    => reg_w_src_sig,
                              do_branch    => do_branch_sig,
                              do_jump      => do_jump_sig,
                              instr_len    => instr_len_sig
                            );
				            
  data_path:    datapath generic map(data_width, reg_addr_width)  port map(
                              clk          => clk,
                              reset        => reset,
 
                              a_addr       => a_addr_sig,
                              b_addr       => b_addr_sig,
                              imm_val      => imm_val_sig,
                              y_addr       => y_addr_sig,
                              pc_next_addr => pc_next_addr_sig,
 
                              alu_ctrl     => alu_ctrl_sig,
                              flag_sel     => flag_sel_sig,
                              imm_w        => imm_w_sig,
                              reg_w_src    => reg_w_src_sig,
                              do_branch    => do_branch_sig,
                              instr_len    => instr_len_sig,
                              do_jump      => do_jump_sig,
 
                              dmem_out     => dmem_out_sig,
 
                              dm_addr      => dm_addr_sig,
                              store_val    => store_val_sig,
                              cur_pc       => cur_pc_sig,


                              dbg_addr     => dbg_addr, -- debugging IO
                              dbg_val      => dbg_val   -- debugging IO
                            );

  data_mem:     datamem  generic map(data_width) port map(
                              clk          => clk,
                              reset        => reset,
                              data_w       => data_w_sig, 
                              cur_pc       => cur_pc_sig,
                              dm_addr      => dm_addr_sig,
                              store_val    => store_val_sig,

                              sw        => sw,
                              btn_write => btn_write,

                              dmem_out     => dmem_out_sig
                            );

  instr_mem:    instrmem generic map(data_width, reg_addr_width)  port map(
                              cur_pc       => cur_pc_sig,
                              op_code      => op_code_sig,
                              y_addr       => y_addr_sig,
                              a_addr       => a_addr_sig,
                              b_addr       => b_addr_sig,
                              imm_val      => imm_val_sig,
                              pc_next_addr => pc_next_addr_sig
                            );
end;
