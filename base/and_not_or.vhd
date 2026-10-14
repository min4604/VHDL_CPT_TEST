-------------------------------------------------------------------
-- 檔案名稱：and_not_or.vhd
-- 功    能：基本邏輯閘組合範例 D = (A AND B) OR (NOT C)
-- 說    明：
--   A、B 先經過 AND 閘得到 w1，C 經過 NOT 閘得到 E，
--   最後 w1 與 E 經 OR 閘輸出到 D。
--   E 宣告為 buffer，因此可同時當作輸出並在內部被讀取。
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity and_not_or is
port(
	 A,B,C : in  std_logic;		-- 三個輸入
	 D     : out std_logic;		-- D = (A and B) or (not C)
	 E	   : buffer std_logic);	-- E = not C (可在內部回讀)
end and_not_or;

architecture a of and_not_or is
signal w1 :std_logic;			-- 內部連線：A and B 的結果
begin
	w1<=A and B;				-- AND 閘
	E <=not c;					-- NOT 閘
	D <=w1 or E;				-- OR 閘
end a;
