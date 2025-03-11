--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package Funkcje is

	-- Definicja typu wyliczeniowego kolko/krzyzyk/brak
	type t_OX is ('-', 'O', 'X');
	
	-- Definicja typu rejestru 3x3
	type t_OX_3x3_register is array(0 to 2, 0 to 2) of t_OX;

	function conv_to_char (sig: std_logic) return character;
	function conv_to_string (inp: std_logic_vector; string_length: integer) return string;
	
	function t_OX_to_std_logic (sig: t_OX) return std_logic;
	
	function t_OX_to_char(sig: t_OX) return character;
end Funkcje;

package body Funkcje is

	function conv_to_char (sig: std_logic) return character is
	begin
		case sig is
			when '1' 	=> return '1';
			when '0' 	=> return '0';
			when 'Z' 	=> return 'Z';
			when others => return 'X';
		end case;
	end function conv_to_char;
	
	
	function conv_to_string (inp: std_logic_vector; string_length: integer) return string is
		variable s: string(1 TO string_length);
	begin
		for i in 0 to (string_length-1) loop
			s(string_length-i) := conv_to_char(inp(i));
		end loop;
		return s;
	end function conv_to_string;
	
	
	function t_OX_to_std_logic (sig: t_OX) return std_logic is
	begin
		case sig is
			when 'O' 	=> return '0';
			when 'X' 	=> return 'X';
			when others => return '-';
		end case;
	end function t_OX_to_std_logic;
	
	
	function t_OX_to_char(sig: t_OX) return character is
	begin
		case sig is
			when 'O' 	=> return 'O';
			when 'X' 	=> return 'X';
			when others => return '-';
		end case;
	end function t_OX_to_char;
 
end Funkcje;
