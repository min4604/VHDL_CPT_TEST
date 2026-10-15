-------------------------------------------------------------------
-- 檔案名稱：calculate_frequencies.vhd
-- 功    能：頻率計 —— 計算 clk_nHz 在 1 秒內的週期數
-- 說    明：
--   1. flag 在每個 clk_1Hz 上升緣反相 → flag 高、低各維持 1 秒。
--   2. flag='1' 的 1 秒內，counter 計數 clk_nHz 的上升緣，
--      counter_buf 保存上一個計數值。
--   3. flag='0' 時將 counter_buf 輸出到 nHz (即量測到的頻率，單位 Hz)，
--      並將 counter 清零，等待下一次量測。
--   res='0' 時非同步清除。
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity calculate_frequencies is
port( 	res 	: in  std_logic;						-- 低態重置
		clk_1Hz : in  std_logic;						-- 1Hz 參考時脈 (閘門時間)
		clk_nHz	: in  std_logic;						-- 待測信號
		nHz 	: out std_logic_vector(63 downto 0)		-- 量測結果

	);
end calculate_frequencies;

architecture a of calculate_frequencies is

signal counter,counter_buf:std_logic_vector(63 downto 0);	-- 計數器、計數暫存
signal flag : std_logic;									-- '1':計數期間, '0':輸出期間

begin
	-- 產生 1 秒計數閘門
	process(clk_1Hz)
	begin
		if res ='0' then
			flag <='0';
		elsif clk_1Hz'event and clk_1Hz ='1' then
			flag <= not flag;
		end if;
	end process;
	
	-- 計數待測信號
	process(flag,clk_nHz)
	begin
		if res ='0' then
			counter<=(others=>'0');
			counter_buf<=(others=>'0');
		elsif flag ='0' then				-- 輸出期間：鎖存結果並清除計數
			counter<=(others=>'0');
			nHz<=counter_buf;
		elsif clk_nHz'event and clk_nHz ='1' then	-- 計數期間
			counter<=counter+1;
			counter_buf<=counter;
		end if;
	end process;
			
	
end a;

