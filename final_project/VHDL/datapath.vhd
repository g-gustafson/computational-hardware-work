library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;

entity datapath is  -- MIPS datapath
  generic(data_width: integer;
          reg_addr_width: integer);
  port(clk, reset:     in  STD_LOGIC;

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
       
       dbg_addr:       in  STD_LOGIC_VECTOR((reg_addr_width-1) downto 0);

       dm_addr:        out STD_LOGIC_VECTOR((data_width - 1) downto 0);
       store_val:      out STD_LOGIC_VECTOR((data_width - 1) downto 0);
       cur_pc:         out STD_LOGIC_VECTOR((data_width - 1) downto 0);
       dbg_val:        out STD_LOGIC_VECTOR((data_width-1) downto 0)
       );
end datapath;

architecture struct of datapath is

---------------------------------------------------------
-- Component Definitions
---------------------------------------------------------

  -- The datapath needs an ALU component
  component alu 
     generic(data_width: integer);
  port(clk, reset: in  STD_LOGIC;
       alu_ctrl:   in  STD_LOGIC_VECTOR(2 downto 0);
       a, b:       in  STD_LOGIC_VECTOR((data_width - 1) downto 0);
       flag_sel:   in  STD_LOGIC_VECTOR(1 downto 0);
       y:          out STD_LOGIC_VECTOR((data_width - 1) downto 0);
       flag:       out STD_LOGIC);
  end component;

  -- The datapath needs a register file component
  component regfile 
     generic(data_width: integer; 
             reg_addr_width: integer);
  port(clk, reset:     in  STD_LOGIC;
       imm_w:          in  STD_LOGIC;
       do_branch:      in  STD_LOGIC;
       y_addr:         in  STD_LOGIC_VECTOR((reg_addr_width-1) downto 0);
       a_addr, b_addr: in  STD_LOGIC_VECTOR((reg_addr_width-1) downto 0);
       imm_val:        in  STD_LOGIC_VECTOR((data_width-1) downto 0);
       write_val:      in  STD_LOGIC_VECTOR((data_width - 1) downto 0);
       return_pc:      in  STD_LOGIC_VECTOR((data_width-1) downto 0);
       dbg_addr:       in  STD_LOGIC_VECTOR((reg_addr_width-1) downto 0);
       a_val, b_val:   out STD_LOGIC_VECTOR((data_width-1) downto 0);
       dbg_val:        out STD_LOGIC_VECTOR((data_width-1) downto 0));
  end component;

  -- The datapath needs an adder component for the program counter  etc. 
  component adder 
     generic(data_width: integer);
  port(a:    in  STD_LOGIC_VECTOR((data_width-1) downto 0);
       b:    in  STD_LOGIC_VECTOR(1 downto 0); 
       y:    out STD_LOGIC_VECTOR((data_width-1) downto 0));
  end component;

  -- The datapath needs an ander component for determining branching
  component ander
     port(a, b: in  STD_LOGIC;
          y:    out STD_LOGIC);
  end component;

  -- The datapath needs a flip-flop register component for program counter etc.
  component flopr 
     generic(data_width: integer);
    port(clk, reset: in  STD_LOGIC;
                  d: in  STD_LOGIC_VECTOR((data_width-1) downto 0);
                  q: out STD_LOGIC_VECTOR((data_width-1) downto 0));
  end component;

  -- The datapath needs a mux2 component for routing data
  component mux2 
     generic(data_width: integer);
    port(d0, d1: in  STD_LOGIC_VECTOR(data_width-1 downto 0);
         s:      in  STD_LOGIC;
         y:      out STD_LOGIC_VECTOR(data_width-1 downto 0));
  end component;
 
---------------------------------------------------------
  
  -- The signals to wire the datapath components together
     signal in_pc:           STD_LOGIC_VECTOR((data_width - 1) downto 0);
     signal branch_flag:     STD_LOGIC;
     signal branch_or_jump:  STD_LOGIC;
     signal alu_out:         STD_LOGIC_VECTOR((data_width - 1) downto 0);
     signal pc_next:         STD_LOGIC_VECTOR((data_width - 1) downto 0);
     signal a_val:           STD_LOGIC_VECTOR((data_width - 1) downto 0);
     signal b_val:           STD_LOGIC_VECTOR((data_width - 1) downto 0);
     signal write_val:       STD_LOGIC_VECTOR((data_width - 1) downto 0);
     signal cur_pc_sig:      STD_LOGIC_VECTOR((data_width - 1) downto 0) := (others => '0');

  begin
    -- Wire up all the components for the datapath unit
     dm_addr <= a_val;
     store_val <= b_val;
     cur_pc <= cur_pc_sig;
<<<<<<< HEAD
     is_branching:  ander                            port map(a => do_branch, 
                                                      b => branch_flag, 
                                                      y => branch
                                                      );

     pc_adder:      adder    generic map(data_width) port map(
                                                      a => cur_pc_sig,
                                                      b => instr_len, 
                                                      y => pc_next
                                                      );
                                                      
     branch_mux:    mux2     generic map(data_width) port map(d0 => pc_next, 
                                                      d1 => pc_next_addr, 
                                                      s => branch, 
=======
     is_branching:  ander    port map(a => do_branch, 
                              b => (branch_flag or do_jump), 
                              y => branch_or_jump
                              );

     pc_adder:      adder    generic map(data_width) port map(a => cur_pc_sig, 
                                                      b => instr_len, 
                                                      y => pc_next
                                                      );

     branch_mux:    mux2     generic map(data_width) port map(d0 => pc_next, 
                                                      d1 => pc_next_addr, 
                                                      s => branch_or_jump, 
>>>>>>> IO
                                                      y => in_pc
                                                      );

     pc_reg:        flopr    generic map(data_width) port map(clk => clk, 
                                                      reset => reset, 
                                                      d => in_pc, 
                                                      q => cur_pc_sig
                                                      );

     reg_file:      regfile  generic map(data_width, reg_addr_width) 
<<<<<<< HEAD
                                                   
=======
>>>>>>> IO
                                                     port map(clk => clk, 
                                                      reset => reset, 
                                                      imm_w => imm_w, 
                                                      do_branch => do_branch, 
                                                      a_addr => a_addr, 
                                                      b_addr => b_addr, 
                                                      y_addr => y_addr, 
                                                      imm_val => imm_val, 
                                                      write_val => write_val, 
<<<<<<< HEAD
                                                      cur_pc => cur_pc_sig, 
                                                      a_val =>a_val, 
                                                      b_val => b_val
=======
                                                      return_pc => cur_pc_sig, 
                                                      a_val => a_val, 
                                                      b_val => b_val, 
                                                      dbg_addr => dbg_addr, 
                                                      dbg_val => dbg_val
>>>>>>> IO
                                                      );

     alu_unit:      alu      generic map(data_width) port map(clk => clk, 
                                                      reset => reset, 
                                                      alu_ctrl => alu_ctrl, 
                                                      flag_sel => flag_sel, 
                                                      a => a_val, 
                                                      b => b_val, 
                                                      y => alu_out, 
                                                      flag => branch_flag
                                                      );

     write_val_mux: mux2     generic map(data_width) port map(d0 => alu_out, 
                                                      d1 => dmem_out, 
                                                      s => reg_w_src, 
                                                      y => write_val
                                                      );
<<<<<<< HEAD
     
=======
>>>>>>> IO

end struct;


