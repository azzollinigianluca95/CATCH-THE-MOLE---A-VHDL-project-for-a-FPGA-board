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


entity whack_a_mole is
    Port ( Clock : in STD_LOGIC;
           Whack : in STD_LOGIC_VECTOR (4 downto 0);
           Reset : in STD_LOGIC;
           Moles : inout STD_LOGIC_VECTOR (4 downto 0);
           Times : out STD_LOGIC_VECTOR (2 downto 0); -- 3 LEDs that signify time remaining 
           Cathodes : out STD_LOGIC_VECTOR (6 downto 0);
           Anodes : out STD_LOGIC_VECTOR (3 downto 0) );
end whack_a_mole;

architecture Behavioral of whack_a_mole is
 
    component divisor is -- This is a clock dividor that runs 2 times per second... This controls the time the Moles apear in this game
        Port ( CLK : in STD_LOGIC;
               CLKout : inout STD_LOGIC);
    end component;
    
    component medium_clock is -- This is a clock dividor that runs 2 times per second... This controls the time the logic looks if you hit the mole
            Port ( CLK : in STD_LOGIC;
                   CLKout : out STD_LOGIC);
    end component;
    
    component random_num_gen is 
        Port ( Clk : in STD_LOGIC;     -- Clock to change random value, should be fast
               Stop : in STD_LOGIC;   -- Stops creating Moles
               Random : out STD_LOGIC_VECTOR(31 downto 0)); -- 32 bit random binary output
    end component;

    signal new_clock : std_logic; 
    signal counter_clock : std_logic; 
    signal random_num : std_logic_vector(31 downto 0);
    
     signal digit1 : integer := 0;
     signal digit2 : integer := 0;
     signal digit3 : integer := 0;
     signal digit4 : integer := 0;
     signal num : unsigned (4 downto 0) := "00000";
     signal sixty_seconds : unsigned (5 downto 0) := "000000";
     signal stop : std_logic := '0';
     
begin

    slow : divisor port map ( CLK => Clock, CLKOUT => new_clock );
    med_clock : medium_clock port map ( CLK => Clock, CLKOUT => counter_clock );
    random : random_num_gen port map ( CLK => Clock, Stop => Stop, Random => random_num );


    process ( Clock, Reset) is 
        Variable second : unsigned (26 downto 0) := "000000000000000000000000000"; -- max is 101111101011110000100000000 or one second
        Variable digit : unsigned (1 downto 0) := "00";
        Variable CLKR : unsigned (19 downto 0) := "00000000000000000000"; -- max is 10010010011111000000 or one minute 
        Variable Cathode : unsigned(6 downto 0) := "0000000"; -- reversed logic so 0 means high 1 means low
        Variable Anode : unsigned(3 downto 0) := "0000"; -- reversed logic so 0 means high 1 means low

    begin    

        if ( Reset = '1' ) then -- Reset position makes all LEDs turn on, stops creating moles and resets all variables 
            second := "000000000000000000000000000";
            sixty_seconds <= "000000";
            CLKR := "00000000000000000000";
            Anodes <= "0000";
            Cathodes <= "0000001" ;
            Times <= "111";  
            stop <= '0';
                        
        elsif ( Rising_edge(Clock) ) then 
            if second = "101111101011110000100000000" then 
                sixty_seconds <= sixty_seconds + 1; 
                second := "000000000000000000000000000";
            else second := second + 1; 
            end if;
            
            case sixty_seconds is 
                when "000000" => Times <= "111";  -- 1 minute left 
                when "011110" => Times <= "011";  -- 30 seconds left
                when "110010" => Times <= "001";  -- 10 seconds left
                when "111100" => Times <= "000"; stop <= '1' ; -- Time is up 
                when others => 
            end case;
            

            if CLKR = "10010010011111000000" then -- this is the logic of the 4 digit seven segment diplay it check/changes the digit at 60 times per second 
                case digit is
                    when "00" => ANODE := "0111";    
                        if digit4 = 0 then CATHODE := "0000001" ;
                        elsif digit4 = 1 then CATHODE := "1001111" ;
                        elsif digit4 = 2 then CATHODE := "0010010" ;
                        elsif digit4 = 3 then CATHODE := "0000110" ;
                        elsif digit4 = 4 then CATHODE := "1001100" ;
                        elsif digit4 = 5 then CATHODE := "0100100" ;
                        elsif digit4 = 6 then CATHODE := "0100000" ;
                        elsif digit4 = 7 then CATHODE := "0001111" ;
                        elsif digit4 = 8 then CATHODE := "0000000" ;
                        elsif digit4 = 9 then CATHODE := "0001100" ;
                        else CATHODE := "1111111" ; 
                        end if;                    
                    when "01" => ANODE := "1011";  
                        if digit3 = 0 then CATHODE := "0000001" ;
                        elsif digit3 = 1 then CATHODE := "1001111" ;
                        elsif digit3 = 2 then CATHODE := "0010010" ;
                        elsif digit3 = 3 then CATHODE := "0000110" ;
                        elsif digit3 = 4 then CATHODE := "1001100" ;
                        elsif digit3 = 5 then CATHODE := "0100100" ;
                        elsif digit3 = 6 then CATHODE := "0100000" ;
                        elsif digit3 = 7 then CATHODE := "0001111" ;
                        elsif digit3 = 8 then CATHODE := "0000000" ;
                        elsif digit3 = 9 then CATHODE := "0001100" ;
                        else CATHODE := "1111111" ;
                        end if;                    
                    when "10" => ANODE := "1101"; 
                        if digit2 = 0 then CATHODE := "0000001" ;
                        elsif digit2 = 1 then CATHODE := "1001111" ;
                        elsif digit2 = 2 then CATHODE := "0010010" ;
                        elsif digit2 = 3 then CATHODE := "0000110" ;
                        elsif digit2 = 4 then CATHODE := "1001100" ;
                        elsif digit2 = 5 then CATHODE := "0100100" ;
                        elsif digit2 = 6 then CATHODE := "0100000" ;
                        elsif digit2 = 7 then CATHODE := "0001111" ;
                        elsif digit2 = 8 then CATHODE := "0000000" ;
                        elsif digit2 = 9 then CATHODE := "0001100" ;
                        else CATHODE := "1111111" ;
                        end if;                    
                    when "11" => ANODE := "1110";
                        if digit1 = 0 then CATHODE := "0000001" ;
                        elsif digit1 = 1 then CATHODE := "1001111" ;
                        elsif digit1 = 2 then CATHODE := "0010010" ;
                        elsif digit1 = 3 then CATHODE := "0000110" ;
                        elsif digit1 = 4 then CATHODE := "1001100" ;
                        elsif digit1 = 5 then CATHODE := "0100100" ;
                        elsif digit1 = 6 then CATHODE := "0100000" ;
                        elsif digit1 = 7 then CATHODE := "0001111" ;
                        elsif digit1 = 8 then CATHODE := "0000000" ;
                        elsif digit1 = 9 then CATHODE := "0001100" ; 
                        else CATHODE := "1111111" ; 
                        end if;                    
                    WHEN OTHERS => ANODE := "1111";
                end case;
                digit := digit + 1; 
                CLKR := "00000000000000000000";
                Cathodes <= std_logic_vector(Cathode);
                Anodes <= std_logic_vector(Anode); 
             else CLKR := CLKR + 1;     
             end if;      
      
        end if;    
    end process;
    
    process ( new_clock ) is 
    begin 

        if ( rising_edge(new_clock) ) then
            num <= random_num(25) & random_num(29) & random_num(5) & random_num(15) & random_num(20);
        end if;
    end process;
    
    process ( counter_clock, Reset ) is
    begin 
        if reset = '1' then 
                digit1 <= 0;
                digit2 <= 0;
                digit3 <= 0;
                digit4 <= 0;
                Moles <= "11111";      
        elsif ( rising_edge(counter_clock) ) then   
            Moles <= std_logic_vector(num);        
            if ( (Whack(4) = '1' and Moles(4) = '1') or 
                 (Whack(3) = '1' and Moles(3) = '1') or 
                 (Whack(2) = '1' and Moles(2) = '1') or 
                 (Whack(1) = '1' and Moles(1) = '1') or 
                 (Whack(0) = '1' and Moles(0) = '1')      ) then 
                    digit1 <= digit1 + 1;
                    if digit1 = 9 then 
                        digit1 <= 0;
                        digit2 <= digit2 + 1;
                        if digit2 = 9 then 
                            digit1 <= 0;
                            digit2 <= 0;
                            digit3 <= digit3 + 1;
                            if digit3 = 9 then 
                                digit1 <= 0;
                                digit2 <= 0;
                                digit3 <= 0;
                                digit4 <= digit4 + 1;
                                if digit4 = 9 then 
                                    digit1 <= 0;
                                    digit2 <= 0;
                                    digit3 <= 0;
                                    digit4 <= 0;
                                end if; 
                            end if;
                        end if; 
                    end if;           
                end if;
            end if;
    end process; 
       
end Behavioral;