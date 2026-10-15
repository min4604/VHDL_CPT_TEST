-------------------------------------------------------------------
-- 檔案名稱：bintobcd.vhd
-- 功    能：10 位元二進位轉 BCD —— 移位加三法 (Double Dabble / Shift-Add-3)
-- 說    明：
--   演算法：每個時脈處理 1 個位元 (由 MSB 到 LSB)，
--     1. 檢查每個 BCD 位數 (4 bit)，若 > 4 則加 3
--     2. 整個 BCD 暫存器左移 1 位，並把輸入的下一個位元移入最低位
--   重複 10 次 (N = 9 → 0) 後即得到 BCD 結果。
--   本範例輸入固定為內部常數 indate = "1001001101" (= 589)，
--   輸出 outdate 為 4 位數 BCD (每 4 bit 一位數)，完成後應為 0589。
--   N 遞減至 -1 時因範圍限制會變成 15 並停止轉換。
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity bintobcd is
port(clk ,reset: in std_logic;						-- 時脈、低態重置 (重置後重新轉換)
	 --indate : in std_logic_vector(9 downto 0);
	 ck:out std_logic;								-- 時脈直接輸出 (觀察用)
	 outdate :out std_logic_vector(15 downto 0 ) );	-- BCD 結果：千/百/十/個
end bintobcd;


architecture a of bintobcd is
signal N : integer range 0 to 15 :=9;						-- 目前處理的輸入位元索引
signal indate :std_logic_vector(9 downto 0):="1001001101";	-- 測試輸入 589
--signal bcd1 :std_logic_vector(15 downto 0);
begin
	-- 位元索引計數器：9 → 0，之後停在 15 (不在 0~9 範圍內即停止轉換)
	process(clk,reset)
	
	begin
		if reset ='0' then
			N<=9;
		elsif clk'event and clk ='1' then 
			if N>=0 and N<=9 then 
				N <= N-1;
				
			 else 
				N<= 15;
			end if;
		end if;
	end process;
	
	-- 移位加三運算
	process(clk,reset)
	variable bcd :std_logic_vector(15 downto 0);	-- BCD 暫存器
	begin
		if reset ='0' then
			
			bcd:="0000000000000000";
		elsif clk'event and clk ='1' then
			if N>=0 and N<=9 then 
				
				
				-- 步驟 1：各位數 > 4 則加 3
				if bcd(15 downto 12) > 4 then
					bcd(15 downto 12) := bcd(15 downto 12) +3;
				else
					--bcd(15 downto 12) <= bcd(15 downto 12);
				end if;
				
				if bcd(11 downto 8) > 4 then
					bcd(11 downto 8) := bcd(11 downto 8) +3;
				else
					--bcd(11 downto 8) <= bcd(11 downto 8);
				end if;
				
				if bcd(7 downto 4) > 4 then
					bcd(7 downto 4) := bcd(7 downto 4) +3;
				else
					--bcd(7 downto 4) <= bcd(7 downto 4);
				end if;
				
				if bcd(3 downto 0) > 4 then
					bcd(3 downto 0) := bcd(3 downto 0) +3;
				else
					--bcd(3 downto 0) <= bcd(3 downto 0);
				end if;
				-- 步驟 2：左移並移入下一個輸入位元
				bcd := bcd(14 downto 0) & '0';
				bcd(0) := indate(N);
			else 
				--bcd <= bcd;
			end if;
			
			outdate <= bcd ;
		end if;
	    ck<=clk;
	end process;
end a;
