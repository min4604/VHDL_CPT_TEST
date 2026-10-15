-------------------------------------------------------------------
-- 檔案名稱：MUX8_1.vhd
-- 功    能：8 對 1 多工器 (PUF 用來選擇要比較的環形振盪器)
-- 說    明：依 S (3 bit) 從 I0~I7 中選出一路輸出到 F。
-- 注    意：with-select 未包含 when others，GHDL 會回報 missing choice，
--           可視需要補上 "when others"。
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX8_1 is
  port (
    I0,I1,I2,I3,I4,I5,I6,I7    	: in  std_logic;					-- 8 路輸入
    S    						: in  std_logic_vector(2 downto 0);	-- 選擇線
    F 							: out std_logic);					-- 輸出
end entity MUX8_1;

architecture a of MUX8_1 is
begin
  with S select
  F<= 	I0 when "000",
		I1 when "001",
		I2 when "010",
		I3 when "011",
		I4 when "100",
		I5 when "101",
		I6 when "110",
		I7 when "111";
end  a;
