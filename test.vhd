----------------------------------------------------------------------------------
-- Autor:	Marcel Cholodecki
--	Indeks:	275818
-- Data:		29.01.2025
-- Uklad:	Glowny uklad kolko i krzyzyk (UUT: TEST)
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

use STD.TEXTIO.ALL;
use ieee.std_logic_textio.all;

use WORK.Funkcje.all;
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uut
    PORT(
         RESET : IN  std_logic;
         COL : IN  std_logic_vector(2 downto 0);
         ROW : IN  std_logic_vector(2 downto 0);
         TURN : OUT  t_OX;
			WINNER: OUT t_OX;
			GAME: OUT t_OX_3x3_register
        );
    END COMPONENT;
    

   -- Sygnaly wejsciowe
   signal RESET : std_logic := '0';
   signal COL : std_logic_vector(2 downto 0) := (others => '0');
   signal ROW : std_logic_vector(2 downto 0) := (others => '0');

 	-- Sygnaly wyjsciowe
   signal TURN : t_OX;
	signal WINNER: t_OX;
	signal GAME: t_OX_3x3_register;
	
	-- Handlery plikow wyjsciowych
	file remis_file: text is out "RESULT_REMIS.txt";
	file win_file: text is out "RESULT_WIN.txt";
	-- Obiekty linii dla plikow wyjsciowych
	shared variable remis_line: line;
	shared variable win_line: line;

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uuta: uut PORT MAP (
          RESET => RESET,
          COL => COL,
          ROW => ROW,
          TURN => TURN,
			 WINNER => WINNER,
			 GAME => GAME
        );
 

   -- Stimulus process
   stim_proc: process
   begin
		wait for 10 ns;
		-- Zwyciestwo 'O' (skos)
		COL <= "001"; ROW <= "001"; wait for 10 ns; COL <= "001"; ROW <= "010"; wait for 10 ns;
		COL <= "010"; ROW <= "010"; wait for 10 ns; COL <= "001"; ROW <= "100"; wait for 10 ns;
		COL <= "100"; ROW <= "100"; wait for 10 ns; COL <= "100"; ROW <= "001"; wait for 10 ns;
		
		COL <= "000"; ROW <= "000";
		
		-- Reset planszy
		RESET <= '1'; wait for 10 ns; RESET <= '0'; wait for 10 ns;
		
		-- Remis
		COL <= "010"; ROW <= "001"; wait for 10 ns; COL <= "001"; ROW <= "001"; wait for 10 ns;
		COL <= "010"; ROW <= "010"; wait for 10 ns; COL <= "100"; ROW <= "001"; wait for 10 ns;
		COL <= "001"; ROW <= "010"; wait for 10 ns; COL <= "100"; ROW <= "010"; wait for 10 ns;
		COL <= "001"; ROW <= "100"; wait for 10 ns; COL <= "010"; ROW <= "100"; wait for 10 ns; 
		COL <= "100"; ROW <= "100"; wait for 10 ns; COL <= "100"; ROW <= "001"; wait for 10 ns;
		
		COL <= "000"; ROW <= "000";
		
		-- Reset planszy
		RESET <= '1'; wait for 10 ns; RESET <= '0'; wait for 10 ns;
		
		-- Invalid inputs
		COL <= "101"; ROW <= "001"; wait for 10 ns;
		COL <= "100"; ROW <= "001"; wait for 10 ns;
		COL <= "010"; ROW <= "010"; wait for 10 ns;
		COL <= "100"; ROW <= "001"; wait for 10 ns;
		
		file_close(remis_file);
		file_close(win_file);
      assert false severity failure;
   end process;
	
	save_remis: process(WINNER, TURN, GAME)
	begin
		if (TURN'event AND TURN = '-') then if (WINNER = '-') then
			for r in 0 to 2 loop
				write(remis_line, t_OX_to_char(GAME(r,0)) & ' ' & t_OX_to_char(GAME(r, 1)) & ' ' & t_OX_to_char(GAME(r, 2)));
				writeline(remis_file, remis_line);
			end loop;
			
			write(remis_line, "_____");
			writeline(remis_file, remis_line);
			write(remis_line, "REMIS");
			writeline(remis_file, remis_line);
			
		end if; end if;
	end process save_remis;
	
	save_win: process(WINNER, TURN, GAME)
	begin
		if (TURN'event AND TURN = '-') then if (WINNER /= '-') then
			for r in 0 to 2 loop
				write(win_line, t_OX_to_char(GAME(r,0)) & ' ' & t_OX_to_char(GAME(r, 1)) & ' ' & t_OX_to_char(GAME(r, 2)));
				writeline(win_file, win_line);
			end loop;
			
			write(win_line, "_____");
			writeline(win_file, win_line);
			write(win_line, "WIN:" & t_OX_to_char(WINNER));
			writeline(win_file, win_line);
			
		end if; end if;
	end process save_win;

END;
