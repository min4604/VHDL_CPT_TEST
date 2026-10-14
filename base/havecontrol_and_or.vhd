-------------------------------------------------------------------
-- 檔案名稱：havecontrol_and_or.vhd
-- 功    能：具控制腳 (致能) 的 AND / OR 閘
-- 說    明：
--   C 為低態致能 (active-low) 控制信號：
--     C='0' 時：X = A(1) AND A(0)，Y = A(1) OR A(0)
--     C='1' 時：X、Y 皆強制為 '0'
--   本範例使用 VHDL 內建的 BIT / BIT_VECTOR 型態 (只有 '0'、'1')。
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity havecontrol_and_or is
port(	A: IN BIT_VECTOR(1 downto 0);	-- 2 位元輸入
		C: IN BIT;						-- 控制腳 (0:致能, 1:關閉)
		X: OUT BIT;						-- AND 結果
		Y: OUT BIT);					-- OR  結果
end havecontrol_and_or ;

architecture a of havecontrol_and_or  is

begin
	X <= A(1) and A(0) and (not C);			-- 受控 AND
	Y <= (A(1) or A(0)) and (not C);		-- 受控 OR
end a;
