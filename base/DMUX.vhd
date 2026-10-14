-------------------------------------------------------------------
-- 檔案名稱：DMUX.vhd
-- 功    能：1 對 8 解多工器 (1-to-8 Demultiplexer)
-- 說    明：
--   依選擇線 S (3 bit) 將單一輸入 D 送到 Y 的第 S 個位元，
--   其餘輸出位元皆為 '0'。
--   例：S="101" 時，Y(5)=D，其他位元為 0。
-- 注    意：with-select 未包含 when others，部分模擬器 (如 GHDL)
--           會回報 missing choice，可視需要補上 "when others"。
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;


entity DMUX is
port(	D	: in  std_logic;						-- 資料輸入
		S	: in  std_logic_vector(2 downto 0);		-- 選擇線 (0~7)
		Y	: out std_logic_vector(7 downto 0)		-- 8 路輸出
	);
end DMUX;

architecture DMUX1_8 of DMUX is
begin
	-- 以聚合 (aggregate) 寫法：指定位元放 D，其餘 (others) 補 0
	with S select
	Y<=	(0=>D,others=>'0') when "000",
		(1=>D,others=>'0') when "001",
		(2=>D,others=>'0') when "010",
		(3=>D,others=>'0') when "011",
		(4=>D,others=>'0') when "100",
		(5=>D,others=>'0') when "101",	
		(6=>D,others=>'0') when "110",
		(7=>D,others=>'0') when "111";
end DMUX1_8;
