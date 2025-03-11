----------------------------------------------------------------------------------
-- Autor:	Marcel Cholodecki
--	Indeks:	275818
-- Data:		29.01.2025
-- Uklad:	Uk³ad rezolucji konfliktów (Conflict Resolver: TEST)
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ConflictResolver_Test IS
END ConflictResolver_Test;
 
ARCHITECTURE behavior OF ConflictResolver_Test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ConflictResolver
    PORT(
         input : IN  std_logic_vector(2 downto 0);
         output : OUT  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal input : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal output : std_logic_vector(2 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ConflictResolver PORT MAP (
          input => input,
          output => output
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      
		input <= "000"; wait for 10 ns;
		input <= "001"; wait for 10 ns;
		input <= "011"; wait for 10 ns;
		input <= "010"; wait for 10 ns;
		
      assert false severity failure;
   end process;

END;
