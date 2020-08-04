----------------------------------------------------------------------------------
-- Company: California Polytechnic State University San Luis Obispo
-- CPE 133
-- Engineer: Juan Gonzalez Aguayo
-- 
-- Create Date: 12/03/2016 10:04:27 PM
-- Design Name: 
-- Module Name: whack_a_mole - Behavioral
-- Project Name: Whack-a-Mole
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity divisor is
    Port ( CLK : in STD_LOGIC;
           CLKout : out STD_LOGIC);
end divisor;

architecture Behavioral of divisor is

    signal toggle : std_logic := '0';

begin

    process ( CLK, Toggle ) is 
        variable count : unsigned(25 downto 0) := "00000000000000000000000000" ;
        constant divisor : unsigned(25 downto 0) :=  "10111110101111000010000000";
        
    begin
        if ( rising_edge(CLK) ) then 
            count := count + 1 ;
            if ( std_logic_vector(count) = std_logic_vector(divisor) ) then 
                count := "00000000000000000000000000";
                toggle <= not toggle; 
            end if;
        end if;
        CLKout <= toggle;
   end process;

end Behavioral;
