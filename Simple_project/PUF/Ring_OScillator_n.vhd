-------------------------------------------------------------------
-- 檔案名稱：Ring_OScillator_n.vhd
-- 功    能：N 階環形振盪器 (Ring Oscillator)
-- 說    明：
--   由 N 個反相器首尾相接 (N 必須為奇數) 形成自激振盪。
--   chain(0) 為「EN AND (NOT 最後一級)」，EN='0' 時停止振盪。
--   振盪頻率由各級反相器的傳遞延遲決定，會因每顆晶片的製程差異
--   而略有不同 —— 這正是 PUF (物理不可複製函數) 利用的特性。
--   syn_keep 屬性可避免合成工具把反相器鏈最佳化掉。
-- 注    意：此電路為組合迴路，合成工具會出現 combinational loop 警告，
--           屬於預期行為；模擬時需搭配延遲模型才會振盪。
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Ring_OScillator_n is
generic(n:integer :=31);--N階環形震盪
port( 	EN 		: in 	std_logic;		-- 致能 ('1' 振盪)
		ck_out	: out  	std_logic		-- 振盪輸出

	);
end Ring_OScillator_n;

architecture Ring_OScillator of Ring_OScillator_n is
signal chain : std_logic_vector(n-1 downto 0);	-- 反相器鏈
attribute syn_keep: boolean;
attribute syn_keep of chain: signal is true;	-- 保留每一級，不被最佳化
begin
	-- 第 1 ~ n-1 級反相器
	genchain:
	for i in 1 to (n-1) generate
	  chain(i) <= not chain(i-1);
	end generate;
	-- 第 0 級：致能閘 + 回授反相
	chain(0)<= en and (not chain(n-1));
	ck_out<=chain(n-1);
end Ring_OScillator;

