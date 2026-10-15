-------------------------------------------------------------------
-- 檔案名稱：bintobcd_sub.vhd
-- 功    能：8 位元二進位轉 3 位數 BCD —— 連續減法法
-- 說    明：
--   start='1' 且 busy='0' 時載入 bin_in 並開始轉換 (busy='1')。
--   之後每個時脈依序嘗試減去 200 / 100 / 50 / 10，
--   並在對應的 BCD 位數加上 2 / 1 / 5 / 1；
--   剩下不足 10 的部分即為個位數，此時 busy 回到 '0' 表示完成。
--   bcd_out(11 downto 8)=百位, (7 downto 4)=十位, (3 downto 0)=個位
--   例：bin_in = 234 → 200 → 10 → 10 → 10 → 個位 4，結果 2_3_4
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bintobcd_sub is
port( clk     : in std_logic;							-- 時脈
	  start   : in std_logic;							-- 啟動轉換
	  bin_in  : in std_logic_vector(7 downto 0);		-- 二進位輸入 (0~255)
	  bcd_out : buffer std_logic_vector(11 downto 0);	-- BCD 輸出：百/十/個
	  busy    : buffer std_logic );						-- '1':轉換中, '0':完成/閒置
end bintobcd_sub;

architecture beh of bintobcd_sub is
begin 
	process(clk)
	variable bin :std_logic_vector(7 downto 0);		-- 剩餘待轉換值
	begin 
		if(clk'event and clk ='1') then
			if start ='1' and busy ='0' then		-- 載入並開始
				bin := bin_in;
				bcd_out <="000000000000";
				busy <='1';
			elsif busy ='1' then					-- 每個時脈減一次
				if(bin>=200) then
					bin :=bin-200;
					bcd_out(11 downto 8) <=bcd_out(11 downto 8) +2;
				elsif (bin>=100) then
					bin :=bin-100;
					bcd_out(11 downto 8) <=bcd_out(11 downto 8) +1;
				elsif (bin>=50) then
					bin :=bin-50;
					bcd_out(7 downto 4) <=bcd_out(7 downto 4) +5;
				elsif (bin>=10) then
					bin :=bin-10;
					bcd_out(7 downto 4) <=bcd_out(7 downto 4) +1;
				else								-- 剩下 0~9 即個位數
					bcd_out(3 downto 0) <=bin(3 downto 0);
					busy <='0';
				end if;
			end if;
		end if;
	end process;
end beh;
