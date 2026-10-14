-------------------------------------------------------------------
-- 檔案名稱：shift_register.vhd
-- 功    能：10 位元可載入左右移位暫存器，結果顯示於 LED
-- 說    明：
--   1. 以 50MHz 時脈驅動 20 位元除頻計數器 DF，
--      取 DF(20) 作為移位時脈 (約 50MHz / 2^20 ≒ 47.7Hz)。
--   2. 依按鍵 bt 決定動作：
--        bt="00" : 由指撥開關 sw 平行載入資料
--        bt="01" : 左移一位 (右側補 0)
--        bt="10" : 右移一位 (左側補 0)
--        bt="11" : 保持不變
--   3. 暫存器內容 dt 直接輸出至 LED。
-- 注    意：case 未包含 when others，GHDL 會回報 missing choice，
--           Quartus 一般可通過；可視需要將 "11" 改為 others。
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity shift_register is
port ( 	clk_50M	:in  std_logic;							-- 系統時脈 50MHz
		sw		:in  std_logic_vector(9 downto 0 );		-- 指撥開關：載入的資料
		bt		:in  std_logic_vector(1 downto 0);		-- 按鍵：選擇動作
		LED		:out std_logic_vector(9 downto 0)		-- 顯示暫存器內容
		
		);
end shift_register;

architecture a of shift_register is
signal dt:std_logic_vector(9 downto 0);		-- 移位暫存器本體

signal DF:std_logic_vector(20 downto 1);	-- 除頻計數器
begin
	-- 除頻器：每個 50MHz 上升緣計數加 1
	process(clk_50M)
	begin
		if clk_50M'event and clk_50M ='1' then
			DF<=DF+1;
		end if;
	end process;

	-- 移位暫存器：使用除頻後的 DF(20) 作為時脈
	process(DF(20),bt)
	begin
		if DF(20)'event and DF(20) ='1' then
			case bt is
				when "00" =>
					dt<=sw;						-- 平行載入
				when "01" =>
					dt<=dt(8 downto 0)&'0';		-- 左移
				when "10" =>
					dt<='0'&dt(9 downto 1);		-- 右移
				when "11" =>
					null;						-- 保持
			end case;
		end if;
	end process;
	LED<=dt;
	
end a;
