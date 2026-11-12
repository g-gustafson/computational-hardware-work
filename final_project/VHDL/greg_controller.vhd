library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;

entity controller is -- single cycle control decoder TODO: finalize due to documentation
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
end;

-- TODO: convert instr_len to bytes not bits
architecture behave of controller is
begin 
  process(op_code) begin
    case op_code is 
      when "0000" => alu_ctrl <= "000"; data_w <= '0'; flag_sel <= "XX"; imm_w <= 'X'; reg_w_src <= 'X'; do_branch <= '0'; do_jump <= '0'; instr_len <= "01";
      when "0001" => alu_ctrl <= "001"; data_w <= '0'; flag_sel <= "XX"; imm_w <= '0'; reg_w_src <= '0'; do_branch <= '0'; do_jump <= '0'; instr_len <= "10";
      when "0010" => alu_ctrl <= "010"; data_w <= '0'; flag_sel <= "XX"; imm_w <= '0'; reg_w_src <= '0'; do_branch <= '0'; do_jump <= '0'; instr_len <= "10";
      when "0011" => alu_ctrl <= "011"; data_w <= '0'; flag_sel <= "XX"; imm_w <= '0'; reg_w_src <= '0'; do_branch <= '0'; do_jump <= '0'; instr_len <= "10";
      when "0100" => alu_ctrl <= "100"; data_w <= '0'; flag_sel <= "XX"; imm_w <= '0'; reg_w_src <= '0'; do_branch <= '0'; do_jump <= '0'; instr_len <= "10";
      when "0101" => alu_ctrl <= "101"; data_w <= '0'; flag_sel <= "XX"; imm_w <= '0'; reg_w_src <= '0'; do_branch <= '0'; do_jump <= '0'; instr_len <= "10";
      when "0110" => alu_ctrl <= "110"; data_w <= '0'; flag_sel <= "XX"; imm_w <= '0'; reg_w_src <= '0'; do_branch <= '0'; do_jump <= '0'; instr_len <= "10";
      when "0111" => alu_ctrl <= "111"; data_w <= '0'; flag_sel <= "XX"; imm_w <= '0'; reg_w_src <= '0'; do_branch <= '0'; do_jump <= '0'; instr_len <= "10";
      when "1000" => alu_ctrl <= "000"; data_w <= '0'; flag_sel <= "XX"; imm_w <= '0'; reg_w_src <= '1'; do_branch <= '1'; do_jump <= '1'; instr_len <= "11";
      when "1001" => alu_ctrl <= "000"; data_w <= '0'; flag_sel <= "XX"; imm_w <= '1'; reg_w_src <= '0'; do_branch <= '0'; do_jump <= '0'; instr_len <= "11";
      when "1010" => alu_ctrl <= "000"; data_w <= '0'; flag_sel <= "XX"; imm_w <= '0'; reg_w_src <= '1'; do_branch <= '0'; do_jump <= '0'; instr_len <= "10";
      when "1011" => alu_ctrl <= "000"; data_w <= '1'; flag_sel <= "XX"; imm_w <= '0'; reg_w_src <= '0'; do_branch <= '0'; do_jump <= '0'; instr_len <= "10";
      when "1100" => alu_ctrl <= "000"; data_w <= '0'; flag_sel <= "00"; imm_w <= '0'; reg_w_src <= '1'; do_branch <= '1'; do_jump <= '0'; instr_len <= "11";
      when "1101" => alu_ctrl <= "000"; data_w <= '0'; flag_sel <= "01"; imm_w <= '0'; reg_w_src <= '1'; do_branch <= '1'; do_jump <= '0'; instr_len <= "11";
      when "1110" => alu_ctrl <= "000"; data_w <= '0'; flag_sel <= "10"; imm_w <= '0'; reg_w_src <= '1'; do_branch <= '1'; do_jump <= '0'; instr_len <= "11";
      when "1111" => alu_ctrl <= "000"; data_w <= '0'; flag_sel <= "11"; imm_w <= '0'; reg_w_src <= '1'; do_branch <= '1'; do_jump <= '0'; instr_len <= "11";
      when others => alu_ctrl <= "000"; data_w <= '0'; flag_sel <= "00"; imm_w <= '0'; reg_w_src <= '0'; do_branch <= '0'; do_jump <= '0'; instr_len <= "00";
    end case;
  end process;
end behave;