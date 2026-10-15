-------------------------------------------------------------------
-- 檔案名稱：MUX.vhd
-- 功    能：8 對 1 多工器 (8-to-1 Multiplexer)
-- 說    明：
--   依選擇線 S (3 bit) 從 8 位元輸入 D 中挑出一個位元輸出到 Y。
--   例：S="011" 時，Y=D(3)。
-- 注    意：with-select 未包含 when others，部分模擬器 (如 GHDL)
--           會回報 missing choice，可視需要補上 "when others"。
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity MUX is
port(	D	:in	 std_logic_vector(7 downto 0);		-- 8 路資料輸入
		S	:in  std_logic_vector(2 downto 0);		-- 選擇線 (0~7)
		Y	:out std_logic							-- 被選中的輸出
	);
end MUX;

architecture MUX8_1 of MUX is
begin
	-- 選擇信號指定 (selected signal assignment)
	with S select
	Y<=	D(0) when "000",
		D(1) when "001",
		D(2) when "010",
		D(3) when "011",
		D(4) when "100",
		D(5) when "101",
		D(6) when "110",
		D(7) when "111";
end MUX8_1;
