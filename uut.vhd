----------------------------------------------------------------------------------
-- Autor:	Marcel Cholodecki
--	Indeks:	275818
-- Data:		29.01.2025
-- Uklad:	Glowny uklad kolko i krzyzyk (UUT)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use WORK.Funkcje.all;

entity uut is
	Port(
		RESET: in std_logic;
		
		COL: in std_logic_vector(2 downto 0);
		ROW: in std_logic_vector(2 downto 0);
		
		TURN: out t_OX;
		WINNER: out t_OX;
		
		GAME: out t_OX_3x3_register
	);
end uut;

architecture uut_arch of uut is

	-- Definicja komponentu rezolucji konfliktow
	component ConflictResolver
		Port (
			input: in std_logic_vector(2 downto 0);
			output: out std_logic_vector(2 downto 0)
		);
	end component ConflictResolver;
	
	-- Sygnaly wewnetrzne wyjsc przetworzonych, bezkonfliktowych wejsc
	signal resolvedROW: std_logic_vector(2 downto 0) := "000";
	signal resolvedCOL: std_logic_vector(2 downto 0) := "000";
	
	-- Flagi przebiegu gry
	signal currentTurn: t_OX := 'O';
	signal currentWinner: t_OX := '-';
	
	-- Rejestr 3x3 (plansza gry)
	signal gameRegister: t_OX_3x3_register := (others => (others => '-'));
	
	-- Sygnal wykorzystany do wymuszenia zmiany flagi obecnej tury
	signal forceTurnToggle: std_logic := '0';
	
	-- Zmienna sledzaca liczbe minionych tur (uzywana przy remisie)
	shared variable turnsElapsed: integer := 0;
	
begin
	
	-- Deklaracje komponentow podrzednych
	rowResolver: ConflictResolver port map(ROW, resolvedROW);
	colResolver: ConflictResolver port map(COL, resolvedCOL);
	
	-- Proces zapisujacy wartosci planszy do rejestru 3x3
	writeToGameRegister: process
	begin
		-- Reset
		if (RESET = '1') then
			gameRegister <= (others => (others => '-'));
			turnsElapsed := 0;
			
		elsif (currentTurn /= '-') then
			
			for r in resolvedROW'range loop for c in resolvedCOL'range loop
			
				-- Odnalezienie wybranej kolumny i rzedu
				if (resolvedCOL(c) = '1' AND resolvedROW(r) = '1') then
				
					-- Sprawdzenie, czy pole jest dostepne (nie zawiera 'O' lub 'X')
					if (gameRegister(r, c) = '-') then
						
						-- Przypisanie wartosci obecnej tury do wybranego pola
						gameRegister(r, c) <= currentTurn;
						
						-- Inkrementacja zmiennej sledzacej liczbe tur
						turnsElapsed := turnsElapsed + 1;
						
						-- Wymuszenie uruchomienia procesu setCurrentTurn
						forceTurnToggle <= '1'; wait for 0 ns; forceTurnToggle <= '0';
					end if;
				end if;
			end loop; end loop;
		end if;
		
		-- Alternatywa dla listy czulosci
		wait on RESET, resolvedROW, resolvedCOL, currentTurn;
	end process writeToGameRegister;
	
	
	-- Proces ustawiajacy flage obecnej tury
	setCurrentTurn: process(RESET, forceTurnToggle)
	begin
		if (RESET = '1') then
			currentTurn <= 'O';
			
		elsif (currentWinner /= '-') then
			-- Blokada przebiegu gry po wykryciu wygranej
			currentTurn <= '-';
			
		elsif (forceTurnToggle'event AND forceTurnToggle = '1') then
			if currentTurn = 'O' then currentTurn <= 'X'; else currentTurn <= 'O'; end if;	-- Zmiana flagi obecnej tury na przeciwna
			if turnsElapsed = 9 then currentTurn <= '-'; end if; 										-- Blokada gry po zapelnieniu planszy (remis)
		end if;
	end process setCurrentTurn;
	
	
	-- Proces ustawiajacy flage wygranej
	winCheck: process(gameRegister)
	begin
		-- Reset flagi zwyciestwa
		if RESET = '1' then
			currentWinner <= '-';
		else
			-- Sprawdzenie skosu 0,0 - 2,2
			if gameRegister(0, 0) = gameRegister(1, 1) AND gameRegister(1, 1) = gameRegister(2, 2) then
				if gameRegister(1, 1) /= '-' then
					currentWinner <= gameRegister(1, 1);
				end if;
			end if;
			
			-- Sprawdzenie skosu 2,0 - 0,2
			if gameRegister(2, 0) = gameRegister(1, 1) AND gameRegister(1, 1) = gameRegister(0, 2) then
				if gameRegister(1, 1) /= '-' then
					currentWinner <= gameRegister(1, 1);
				end if;
			end if;
			
			-- Sprawdzenie kazdego rzedu
			for r in 2 downto 0 loop
				if gameRegister(r, 0) = gameRegister(r, 1) AND gameRegister(r, 1) = gameRegister(r, 2) then
					if gameRegister(r, 0) /= '-' then
						currentWinner <= gameRegister(r, 0);
					end if;
				end if;
			end loop;
			
			-- Sprawdzenie kazdej kolumny
			for c in 2 downto 0 loop
				if gameRegister(0, c) = gameRegister(1, c) AND gameRegister(1, c) = gameRegister(2, c) then
					if gameRegister(0, c) /= '-' then
						currentWinner <= gameRegister(0, c);
					end if;
				end if;
			end loop;
		end if;
		
	end process winCheck;
	
	-- Wspolbiezne przypisanie sygnalow do wyjsc
	TURN <= currentTurn;
	WINNER <= currentWinner;
	GAME <= gameRegister;

end architecture uut_arch;

