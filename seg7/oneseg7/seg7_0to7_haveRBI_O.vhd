-------------------------------------------------------------------
-- 檔案名稱：seg7_0to7_haveRBI_O.vhd
-- 功    能：3 位元 (0~7) 轉七段顯示器解碼器 (共陽極，低態點亮)，含消零控制
-- 說    明：
--   seg(7 downto 1) = a b c d e f g，seg(0) = 小數點 (固定 '1' 熄滅)
--   bcd = 0 且 RBI = '0' 時全滅 (消除前導 0)。
-- 注    意：RBO 的判斷式將 3 位元的 bcd 與 4 位元的 "0000" 比較，
--           長度不同永遠不相等，因此 RBO 恆為 '1'；
--           若要正確輸出 RBO，應改為 bcd = "000"。
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity seg7_0to7_haveRBI_O is
	port(	bcd : in  std_logic_vector(2 downto 0);		-- 輸入 0~7
			RBI : in  std_logic;						-- 消零輸入
			RBO : out std_logic;						-- 消零輸出
			seg : out std_logic_vector(7 downto 0)		-- abcdefg + dp
		);
end seg7_0to7_haveRBI_O;

architecture a of seg7_0to7_haveRBI_O is

begin
	--          abcdefg+dp
	seg<= 	"00000011" when (bcd = "000")and RBI ='1' else	-- 0
			"10011111" when bcd="001" else	-- 1
			"00100101" when bcd="010" else	-- 2
			"00001101" when bcd="011" else	-- 3
			"10011001" when bcd="100" else	-- 4
			"01001001" when bcd="101" else	-- 5
			"01000001" when bcd="110" else	-- 6
			"00011111" when bcd="111" else	-- 7
			"11111111" ;					-- 全滅
	RBO<= '0' when (RBI='0' and bcd ="0000") else
		  '1' ;
end a;
