-------------------------------------------------------------------
-- 檔案名稱：LED8X8.vhd
-- 功    能：8x8 LED 點矩陣掃描顯示 + 圖形旋轉 (位元循環右移) 動畫
-- 說    明：
--   1. div 為除頻計數器：
--        scan_clk = div(16) (約 763Hz) → 行掃描
--        text_clk = div(23) (約 6Hz)   → 動畫更新
--   2. li 為目前掃描的行 (0~7)，COL 以 one-hot 選取該行，
--      ROW_d 為該行要顯示的圖形資料 char0~char7。
--      pwm_in='1' 時才前進掃描，可用 PWM 信號調整亮度/閃爍。
--   3. reset='0' 時載入預設圖形；之後每個 text_clk：
--        r='0' : 每一行資料循環右移 1 位 (圖形水平捲動)
--        r='1' : 暫停 (原本的上下捲動程式碼已註解)
-- 注    意：ROW_d 目前沒有指定給輸出埠 ROW，
--           實際使用時需加上 "ROW <= ROW_d;" (或依硬體極性反相) 才會顯示。
-------------------------------------------------------------------
library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity LED8X8 is
port( reset,clk,r :in std_logic;				-- 低態重置、50MHz 時脈、暫停捲動
	  pwm_in:in std_logic;						-- 掃描致能 (PWM 調光)
	  ROW :out std_logic_vector(7 downto 0);	-- 列資料
	  COL :out std_logic_vector(7 downto 0));	-- 行選擇 (one-hot)
end LED8X8;

architecture a of LED8X8 is
signal div :std_logic_vector(23 downto 1);		-- 除頻計數器
signal scan_clk:std_logic;						-- 行掃描時脈
signal text_clk:std_logic;						-- 動畫時脈
signal li:integer range 0 to 7;					-- 目前掃描行
signal char0 :std_logic_vector(7 downto 0);		-- 第 0~7 行的圖形資料
signal char1 :std_logic_vector(7 downto 0);
signal char2 :std_logic_vector(7 downto 0);
signal char3 :std_logic_vector(7 downto 0);
signal char4 :std_logic_vector(7 downto 0);
signal char5 :std_logic_vector(7 downto 0);
signal char6 :std_logic_vector(7 downto 0);
signal char7 :std_logic_vector(7 downto 0);
signal temp  :std_logic_vector(7 downto 0);		-- 上下捲動暫存 (目前未使用)
signal row_d :std_logic_vector(7 downto 0);		-- 目前行要輸出的資料
begin
	-- 除頻器
	process(clk,reset)
	begin
		if reset ='0' then
			div<="00000000000000000000000";
		elsif clk'event and clk ='1' then
			div <= div +1;
		end if;
	end process;
	scan_clk <=div(16);
	text_clk <=div(23);

	-- 行掃描計數 0 → 7 循環
	process(scan_clk,reset)
	begin
		if reset ='0' then
			li <=0;
		elsif ( scan_clk'event and scan_clk ='1') and pwm_in='1' then
			if li =7 then
				li <=0;
			else
				li<=li+1;
			end if;
		end if;
	end process;
	
	-- 圖形資料：重置載入、之後循環移位產生動畫
	process(text_clk,reset,r)
	begin
		if reset ='0' then
			char0 <="10111110";
			char1 <="01011101";
			char2 <="10111011";
			char3 <="11110111";
			char4 <="11101111";
			char5 <="11011101";
			char6 <="10111010";
			char7 <="01111101";
			
		elsif text_clk'event and text_clk ='1' then
			if r= '1' then
				--temp <=char0;
				--char0<=char1;
				--char1<=char2;
				--char2<=char3;
				--char3<=char4;
				--char4<=char5;
				--char5<=char6;
				--char6<=char7;
				--char7<=temp;
			else
				-- 每行循環右移 1 位
				char0<=char0(0)& char0(7 downto 1) ;
				char1<=char1(0)& char1(7 downto 1) ;
				char2<=char2(0)& char2(7 downto 1) ;
				char3<=char3(0)& char3(7 downto 1) ;
				char4<=char4(0)& char4(7 downto 1) ;
				char5<=char5(0)& char5(7 downto 1) ;
				char6<=char6(0)& char6(7 downto 1) ;
				char7<=char7(0)& char7(7 downto 1) ;
			end if;
			
		end if;
	end process;
	
	-- 行選擇 (one-hot)
	with li select
		COL <= "10000000" when 0,
			   "01000000" when 1,
			   "00100000" when 2,
			   "00010000" when 3,
			   "00001000" when 4,
			   "00000100" when 5,
			   "00000010" when 6,
			   "00000001" when 7,
			   "11111111" when others;
			   
	-- 目前行的圖形資料
	with li  select
		ROW_d <= char0 when 0,
			     char1 when 1,
			     char2 when 2,
			     char3 when 3,
			     char4 when 4,
			     char5 when 5,
			     char6 when 6,
			     char7 when 7,
			     "11111111" when others;
	
end a;
