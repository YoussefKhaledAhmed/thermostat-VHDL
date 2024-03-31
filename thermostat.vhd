library ieee;
use ieee.std_logic_1164.all;  -- Include the std_logic_1164 library
use IEEE.NUMERIC_STD.ALL;

entity THERMOSTAT_pins is

--                      __
--      desired_temp ->|  |_
--                     |    |_
--      current_temp ->|      |
--                     |      |-> temp_display
--                     |     _|
--    display_select ->|   _|
--                     |__|
--
port (current_temp : in bit_vector(6 downto 0);
      desired_temp : in bit_vector(6 downto 0);
      display_select : in bit;
      COOL         : in bit;
      HEAT         : in bit;
      temp_display : out bit_vector(6 downto 0);
      A_C_ON       : out Boolean;
      FURNACE_ON   : out Boolean);

end THERMOSTAT_pins;


--> this architecture has 2 approaches:
--> 1. through if statement. --> ** NOTE **: this approach 
-->                                          is commented.
--> 2. through AND, and OR operations.
architecture THERMOSTAT_arch of THERMOSTAT_pins is
begin

  --> 1. 1st approach using if statement.
  ----------------------------------------------------------
  -- process to assign the desired temp to the temp_display
  -- according to the value of display_select
  -- 0 -> desired_temp
  -- 1 -> current_temp
  ----------------------------------------------------------
  --process (current_temp,desired_temp,display_select)
  --begin 

    --if display_select = '0' then

      --temp_display <= desired_temp;

    --elsif display_select = '1' then

      --temp_display <= current_temp;

    --end if;

  --end process;  


---------------------------------------------------------------
  --> 2. 2nd approach using AND, and OR operations:
  process (current_temp,desired_temp,display_select)
    -- mask_temp: is an internal variable where it shall hold
    --            000000 -> if display_select = '0'
    --            111111 -> if display_select = '1'
    variable mask_temp : bit_vector(6 downto 0);
  begin

    -- case statement: to check whether the display_select is:
    -- 1. '0'
    -- 2. '1'
    case display_select is
      --> if display_select = '0' then assign mask_temp to 000000
      when '0' => mask_temp := (others => '0');
      --> if display_select = '1' then assign mask_temp to 111111
      when '1' => mask_temp := (others => '1');
    end case;

    --> here we have two scenarios:
    --> a. display_select = '0': then mask_temp = '000000' when
    -->                          NOT mask_temp --> 111111 and 
    -->                          when: A --> desired_temp and (not mask_temp) -> desired_temp
    -->                                B --> current_temp and mask_temp -> 000000
    -->                          then A or B -> desired_temp.
    --> b. display_select = '1': then mask_temp = '111111'
    -->                          NOT mask_temp --> 000000 and 
    -->                          when: A --> desired_temp and (not mask_temp) -> 000000
    -->                                B --> current_temp and mask_temp -> current_temp
    -->                          then A or B -> current_temp.
    temp_display <= ((desired_temp and (not mask_temp)) or (current_temp and mask_temp));

  end process;

  --> process to control the A/C
  COOL_PROC : process (COOL , current_temp , desired_temp)
  begin
    --> checking the value of the COOL signal 
    case COOL is
      --> case '0' -> turn off the A/C (i.e., A_C_ON <= FALSE)
      when '0' => A_C_ON <= FALSE;
      
      --> case '1' -> check if the desired temp is less than the current temp
      -->             or not.
      when '1' => 
	--> if the desired temp is less than the curren temp
	--> then turn on the A/C (i.e., A_C_ON <= TRUE)
	if desired_temp < current_temp then
	  A_C_ON <= TRUE;
	
	--> if not then turn off the A/C (i.e., A_C_ON <= FALSE)
	else
	  A_C_ON <= FALSE;
	end if;

    end case;
    
  end process COOL_PROC;


  --> process to control the furnace
  HEAT_PROC : process (HEAT , current_temp , desired_temp)
  begin
    --> checking the value of the HEAT signal 
    case HEAT is
      --> case '0' -> turn off the furnace (i.e., FURNACE_ON <= FALSE)
      when '0' => 
        FURNACE_ON <= FALSE;
      
      --> case '1' -> check if the desired temp is greater than the current temp
      -->             or not.
      when '1' =>
	--> if the desired temp greater than the curren temp
	--> then turn on the furnace (i.e., FURNACE_ON <= TRUE)
	if desired_temp > current_temp then
	  FURNACE_ON <= TRUE;
	
	--> if not then turn off the furnace (i.e., FURNACE_ON <= FALSE) 
	else
	  FURNACE_ON <= FALSE;
	end if;

    end case;
  end process HEAT_PROC;


end THERMOSTAT_arch;