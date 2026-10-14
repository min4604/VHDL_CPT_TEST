-------------------------------------------------------------------
-- 檔案名稱：FA_4bit.vhd
-- 功    能：4 位元加法器 (行為描述)
-- 說    明：
--   直接使用 std_logic_unsigned 的 "+" 運算子完成加法，
--   A 先補一個 '0' 擴展成 5 位元，使結果可保留最高位進位。
--   LED(4) 為進位，LED(3 downto 0) 為和。
-------------------------------------------------------------------
library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity FA_4bit is
port(	A,B :in  std_logic_vector(3 downto 0);	-- 兩個 4 位元加數
		LED :out std_logic_vector(4 downto 0)	-- 5 位元結果 (含進位)
	);
end FA_4bit;

architecture FA of FA_4bit is
begin
	LED<=('0'&A)+B;		-- 擴展為 5 位元後相加
end FA;
