----------------------------------------------------------------------------------
-- Autor:	Marcel Cholodecki
--	Indeks:	275818
-- Data:		29.01.2025
-- Uklad:	Uk³ad rezolucji konfliktów (Conflict Resolver)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ConflictResolver is
	Port(
		input: in std_logic_vector(2 downto 0);
		output: out std_logic_vector(2 downto 0)
	);
end ConflictResolver;

architecture ConflictResolver_Arch of ConflictResolver is
	signal preOutput: std_logic_vector(2 downto 0) := (others => '0');
begin

	findConflict: process(input)
		variable bitsSet: Integer := 0;
	begin
		preOutput <= input;
		bitsSet := 0;
		for i in input'range loop
			if (input(i)) = '1' then
				bitsSet := bitsSet + 1;
			end if;
		end loop;
		
		if (bitsSet > 1) then
			-- jesli wektor wejsciowy ma wiecej niz jeden element '1', to na wyjscie wystaw "000". Jesli nie, wystaw wejscie
			preOutput <= (others => '0');
		end if;
	end process findConflict;
	
	output <= preOutput;

end ConflictResolver_Arch;