-------------------------------------------------------------------
-- 檔案名稱：seg7.vhd
-- 功    能：BCD 轉單顆七段顯示器解碼器 (共陽極，低態點亮)，含小數點與消零控制
-- 說    明：
--   seg(7 downto 1) = a b c d e f g，seg(0) = 小數點 (dot)
--   '0' 表示該段點亮 (共陽極)，例：0 → "0000001"。
--   RBI (Ripple Blanking Input，消零輸入)：
--     bcd = 0 且 RBI = '0' 時不顯示 (全滅)，用於去除多位數的前導 0；
--     RBO (Ripple Blanking Output) 此時輸出 '0'，可串接給下一位的 RBI。
--   bcd 為 10~15 時亦全滅。
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity seg7 is
	port(	bcd : in  std_logic_vector(3 downto 0);		-- BCD 輸入 0~9
			dot : in  std_logic;						-- 小數點 ('0' 點亮)
			RBI : in  std_logic;						-- 消零輸入
			RBO : out std_logic;						-- 消零輸出
			seg : out std_logic_vector(7 downto 0)		-- abcdefg + dp
		);
end seg7;

architecture a of seg7 is

begin
	--          abcdefg
	seg<= 	"0000001" & dot when (bcd = "0000")and RBI ='1' else	-- 0 (RBI='0' 時落到最後一行而全滅)
			"1001111" & dot when bcd="0001" else	-- 1
			"0010010" & dot when bcd="0010" else	-- 2
			"0000110" & dot when bcd="0011" else	-- 3
			"1001100" & dot when bcd="0100" else	-- 4
			"0100100" & dot when bcd="0101" else	-- 5
			"0100000" & dot when bcd="0110" else	-- 6
			"0001111" & dot when bcd="0111" else	-- 7
			"0000000" & dot when bcd="1000" else	-- 8
			"0000100" & dot when bcd="1001" else	-- 9
			"1111111" & dot ;						-- 全滅
	-- 本位數被消零時 RBO='0'，通知下一位數也可消零
	RBO<= '0' when (RBI='0' and bcd ="0000") else
		  '1' ;
end a;
