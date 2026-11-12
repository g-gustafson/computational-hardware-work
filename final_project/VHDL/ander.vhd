library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
entity ander is
  port(a, b: in  STD_LOGIC;
       y:    out STD_LOGIC);
end;

architecture behave of ander is
begin
  y <= a and b;
end;
