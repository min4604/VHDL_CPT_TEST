-------------------------------------------------------------------
-- 檔案名稱：bin8toseg7.vhd
-- 功    能：8 位元二進位轉 BCD (移位加三法)，並以 4 位數七段顯示器掃描顯示
-- 說    明：
--   1. div 為除頻計數器：
--        run_clk = div(1)  (50MHz/2 = 25MHz)   → 驅動 BCD 轉換
--        COL_clk = div(17) (約 381Hz)          → 驅動七段顯示器掃描
--   2. 重置後 N 由 7 遞減到 0，每個 run_clk 處理輸入 indate 的 1 個位元，
--      轉換期間 busy='1'，完成後 busy='0'，結果存於 bcdall。
--      (轉換完成後 N 停在 15，需再次 reset 才會重新轉換)
--   3. r 為 2 位元掃描計數器，依序點亮 4 個位數 (COL 低態選取)，
--      並將對應的 BCD 位數解碼為七段碼 (共陰極、高態點亮，順序 abcdefg)。
-- 修    正：原檔中有兩行不完整的敘述
--           "conv_std_logic_vector()" 與 "conv_integer;"，
--           會造成編譯錯誤，已改為註解。
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity bin8toseg7 is
port(clk ,reset: in std_logic;							-- 50MHz 時脈、低態重置
	 indate : in std_logic_vector(7 downto 0);			-- 8 位元二進位輸入
	 seg7 :out std_logic_vector(6 downto 0 );			-- 七段碼 abcdefg
	 COL    : out std_logic_vector(3 downto 0);			-- 位數掃描 (低態選取)
	 busy   :buffer std_logic );						-- '1':轉換中
end bin8toseg7;


architecture a of bin8toseg7 is
signal N : integer range 0 to 15 :=7;					-- 目前處理的輸入位元索引
signal bcd_out :std_logic_vector(3 downto 0);			-- 目前掃描位數的 BCD
signal bcdall :std_logic_vector(15 downto 0);			-- 轉換結果：千/百/十/個

signal div :std_logic_vector(23 downto 1);				-- 除頻計數器
signal COL_clk:std_logic;								-- 掃描時脈
signal run_clk:std_logic;								-- 轉換時脈
signal r : std_logic_vector(1 downto 0);				-- 掃描位數計數
begin

	-- 除頻器
	process(clk,reset)
	begin
		if reset ='0' then
			div <="00000000000000000000000";
		elsif clk'event and clk ='1' then
			div<=div+1;
		end if;
	end process;
	COL_clk <=div(17);
	run_clk <=div(1);

	-- 位元索引計數器：7 → 0，之後停在 15
	process(run_clk,reset)
	begin
		if reset ='0' then
			N<=7;
		elsif run_clk'event and run_clk ='1' then 
			if N>=0 and N<=7 then 
				N <= N-1;
				busy<='1';
			 else 
				N<= 15;
				busy<='0';
			end if;
		end if;
	end process;
	 -- conv_std_logic_vector()
	 -- conv_integer;

	-- 移位加三 (Double Dabble) 轉換
	process(run_clk,reset)
	variable bcd :std_logic_vector(15 downto 0);
	begin
		if reset ='0' then
			bcd :="0000000000000000";
			bcdall<="0000000000000000";
		elsif run_clk'event and run_clk ='1' then
			
			if N>=0 and N<=7 then 
				
				
				-- 步驟 1：各位數 > 4 則加 3
				if bcd(15 downto 12) > 4 then
					bcd(15 downto 12) := bcd(15 downto 12) +3;
				end if;
				
				if bcd(11 downto 8) > 4 then
					bcd(11 downto 8) := bcd(11 downto 8) +3;
				end if;
				
				if bcd(7 downto 4) > 4 then
					bcd(7 downto 4) := bcd(7 downto 4) +3;
				end if;
				
				if bcd(3 downto 0) > 4 then
					bcd(3 downto 0) := bcd(3 downto 0) +3;
				end if;
				-- 步驟 2：左移並移入下一個輸入位元
				bcd := bcd(14 downto 0) & '0';
				bcd(0) := indate(N);
			else
				bcd:=bcd;
			end if;
			 
		end if;
	bcdall<=bcd;
	end process;
	
	-- 掃描位數計數器
	process(COL_clk)
	begin
		if reset ='0'then
			r<="00";
		elsif COL_clk'event and COL_clk ='1' then
			r<=r+1;
		end if;
	end process;
	
	-- 位數選擇 (低態點亮)
	with r select
		COL <= "0111" when "00",
			   "1011" when "01",
			   "1101" when "10",
			   "1110" when "11",
			   "1111" when others;
	-- 取出目前位數的 BCD 值
	with r select
		bcd_out <= bcdall(15 downto 12) when "00",
				   bcdall(11 downto 8) when "01",
			       bcdall(7 downto 4) when "10",
			       bcdall(3 downto 0) when "11",
			        "0000"  when others;
	-- BCD → 七段碼 (高態點亮，abcdefg)
	with bcd_out select
		seg7<=  "1111110" when "0000",
				"0110000" when "0001",
				"1101101" when "0010",
				"1111001" when "0011",
				"0110011" when "0100",
				"1011011" when "0101",
				"1011111" when "0110",
				"1110000" when "0111",
				"1111111" when "1000",
				"1111011" when "1001",
				"1111111" when others;
	
end a;
