----------------------------------------------------------------------------------
-- Company: Cal Poly  CPE 133
-- Engineer: Paul Hummel
-- 
-- Create Date: 12/07/2016 01:59:18 PM
-- Design Name: 
-- Module Name: RandGen - Behavioral
-- Project Name: Random Number Generator
-- Description: Implement a linear feedback shift register to create a uniform  
--              pseudo random number generator of 32 bits
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity random_num_gen is
    Port ( Clk : in STD_LOGIC;     -- Clock to change random value, should be fast
           STOP : in STD_LOGIC;   -- Reset to preset Seed value when high
           Random : out STD_LOGIC_VECTOR(31 downto 0)); -- 32 bit random binary output
end random_num_gen;

architecture Behavioral of random_num_gen is

    constant SEED : std_logic_vector(31 downto 0) := "01101011000111001100101000010100";    -- initial seed value
    signal randreg : std_logic_vector(31 downto 0) := SEED;                                 -- initialize LSFR
    signal feedback : std_logic;

begin
    
    -- taps at bits 32,22,2,1 (Xilinx xapp210 Documentation)
    feedback <= not((randreg(31) xor randreg(21) xor randreg(1) xor randreg(0))); -- update

    process (clk) is
    begin
        if STOP = '1' then  -- if reset, set random number back to initial seed value
            randreg <= "00000000000000000000000000000000";
        elsif rising_edge(clk) then
            randreg <= randreg(30 downto 0) & feedback; -- shift and include feedback
        end if;
    end process;

    random <= randreg(31 downto 0);

end Behavioral;