library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;

entity adder is 
  generic(data_width: integer);
  port(a:   in  STD_LOGIC_VECTOR((data_width-1) downto 0);
       b:   in  STD_LOGIC_VECTOR(1 downto 0);
       y:   out STD_LOGIC_VECTOR((data_width-1) downto 0));
end;

architecture behave of adder is
begin
  y <= STD_LOGIC_VECTOR(unsigned(a) + unsigned(b));
end;
