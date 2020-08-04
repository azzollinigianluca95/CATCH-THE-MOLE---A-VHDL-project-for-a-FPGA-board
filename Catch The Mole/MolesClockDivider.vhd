----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/07/2016 03:13:31 PM
-- Design Name: 
-- Module Name: Moles_clock_divider - Behavioral
-- Project Name: 
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Moles_clock_divider is
    Port ( CLK : in STD_LOGIC;
           CLKout : out STD_LOGIC);
end Moles_clock_divider;

architecture Behavioral of Moles_clock_divider is

    signal toggle : std_logic := '0';

begin

    process ( CLK, Toggle ) is 
        variable count : unsigned(23 downto 0) := "000000000000000000000000" ;
        constant divisor : unsigned(23 downto 0) :=  "101111101011110000100000";
        
    begin
        if ( rising_edge(CLK) ) then 
            count := count + 1 ;
            if ( std_logic_vector(count) = std_logic_vector(divisor) ) then 
                count := "000000000000000000000000";
                toggle <= not toggle; 
            end if;
        end if;
        CLKout <= toggle;
   end process;

end Behavioral;