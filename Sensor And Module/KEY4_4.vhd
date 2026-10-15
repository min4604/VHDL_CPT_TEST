-------------------------------------------------------------------
-- 檔案名稱：KEY4_4.vhd
-- 功    能：4x4 矩陣鍵盤掃描 + 按鍵除彈跳
-- 說    明：
--   1. Div 為除頻計數器，scan_clk = Div(18) (50MHz/2^18 ≒ 191Hz)。
--   2. scan_code 為 4 位元掃描碼：
--        scan_code(3 downto 2) 選擇要拉低的行 COL (低態掃描)
--        scan_code(1 downto 0) 選擇要讀取的列 ROW → Press
--      沒有按鍵時 (Press='1') scan_code 持續加 1 輪流掃描 16 個鍵；
--      有按鍵時 (Press='0') scan_code 停住，即為按鍵編號 0~15。
--   3. 除彈跳：
--        連續 5 次讀到 '0' (Zero="101") 且之前已放開 → Vaild 輸出一個 '0' 脈波
--        連續 5 次讀到 '1' (One ="101")              → Free='1' 表示按鍵已放開
--   輸出：bt_dt_out = 按鍵編號，vail = 有效按鍵脈波 (低態)，fre = 已放開
-- 注    意：掃描 process 的 COL / Press 為組合邏輯卻放在時脈 process 中，
--           敏感列表只有 scan_clk，模擬時結果可能與合成不同。
-------------------------------------------------------------------
library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity key4_4 is
port( reset, clk : in std_logic;							-- 低態重置、50MHz 時脈
	  ROW:in std_logic_vector(3 downto 0);					-- 鍵盤列輸入 (需上拉)
	  COL:out std_logic_vector(3 downto 0);					-- 鍵盤行掃描輸出 (低態)
	  vail :out std_logic;									-- 有效按鍵 (低態脈波)
	  fre  :out std_logic;									-- 按鍵已放開
	  bt_dt_out:out std_logic_vector(3 downto 0) );		-- 按鍵編號 0~15
end key4_4;

architecture a of key4_4 is
signal scan_clk :std_logic;							-- 掃描時脈
signal  div     :std_logic_vector(22 downto 1);		-- 除頻計數器
signal scan_code:std_logic_vector(3 downto 0);		-- 掃描碼 (行 2 bit + 列 2 bit)
signal Zero :std_logic_vector(2 downto 0);			-- 連續讀到 0 的次數
signal One  :std_logic_vector(2 downto 0);			-- 連續讀到 1 的次數
signal Press:std_logic;  --除彈跳前
signal Vaild:std_logic;  --除彈跳後
signal Free :std_logic;  --按鍵放開'1'
signal Bcdall  :std_logic_vector(15 downto 0);		-- (未使用)
signal bcd:std_logic_vector(3 downto 0);			-- (未使用)
signal bcd_out:std_logic_vector(3 downto 0);		-- (未使用)

begin
	-- 除頻器
	process( clk,reset)
	begin 
		if reset ='0' then
			Div <="0000000000000000000000";
		elsif clk'event and clk ='1' then
			Div <=Div +1;
		end if;
	end process;
	scan_clk <=Div(18);
	
	--鍵盤掃描
	process(scan_clk)
	begin
		-- 依掃描碼高 2 位拉低其中一行
		case scan_code(3 downto 2) is
			when "00" => COL <="1110";
			when "01" => COL <="1101";
			when "10" => COL <="1011";
			when "11" => COL <="0111";
			when others => null;
		end case;
		-- 依掃描碼低 2 位讀取其中一列
		case scan_code(1 downto 0) is
			when "00" => Press <=ROW(0);
			when "01" => Press <=ROW(1);
			when "10" => Press <=ROW(2);
			when "11" => Press <=ROW(3);
			when others => null;
		end case;
		
		if reset ='0' then
			Zero <="000";
			One <="000";
			Vaild <='1';
		elsif scan_clk'event and scan_clk ='1' then
			if press ='1' then				-- 此鍵未按下：繼續掃描下一鍵
				scan_code <=scan_code+1;
				Zero <="000";
				One <= One +1;
			elsif press ='0' then			-- 此鍵按下：停在此掃描碼
				Zero <=Zero+1;
				One <="000";
			end if;
			
			-- 連續 5 次按下且先前已放開 → 輸出一次有效按鍵
			if Zero ="101" and free ='1' then
				vaild <='0';
				free <='0';
			else
				vaild <='1';
			end if;
			
			-- 連續 5 次未按下 → 判定已放開
			if One ="101" then
				free <='1';
				Zero <="000";
			end if;
		end if;
	end process;
	vail<=vaild;
	fre<=free;
	bt_dt_out<=scan_code;

end a;
