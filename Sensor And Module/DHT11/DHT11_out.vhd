-------------------------------------------------------------------
-- 檔案名稱：DHT11_out.vhd
-- 功    能：DHT11 溫濕度讀取頂層 (週期性讀取並鎖存結果)
-- 說    明：
--   1. DF 為除頻計數器 (clk 50MHz)：
--        DHT11_CLK = DF(5)  → 50MHz/64 = 781.25kHz (1.28us)，供 DHT11_driver 使用
--        run       = DF(15) → 約 763Hz，控制讀取流程
--   2. 讀取流程 (run 上升緣)：
--        DHT11_RESET='0' → 設為 '1' 啟動 driver 讀取，並將 delTT 設為 1500
--        DHT11_ok='1'    → 鎖存溫濕度到輸出，delTT 遞減，
--                          倒數到 0 (約 2 秒) 後重新 reset driver 進行下一次讀取
--   3. 輸出：BoT_int/BoH_int 為整數溫度/濕度，BoT/BoH 為 8 位元原始值，
--      DHT_OK='1' 表示已有有效資料。
-- 相依元件：DHT11_driver.vhd
-------------------------------------------------------------------
Library IEEE;
	Use IEEE.std_logic_1164.all;
	Use IEEE.std_logic_unsigned.all;
-- ----------------------------------------------------
Entity DHT11_out is
port(clk,reset:in std_logic;							-- 50MHz 時脈、低態重置
	 DHT11_D_io:inout std_logic;						-- DHT11 資料腳 (需上拉電阻)
	 DHT_OK:out std_logic;								-- 資料有效旗標
	 BoT_int,BoH_int:out integer range 0 to 99;			-- 溫度、濕度 (整數)
	 BoH,BoT:out std_logic_vector(7 downto 0) );		-- 濕度、溫度 (8 位元)
end DHT11_out;

architecture a of DHT11_out is
component  DHT11_driver is
	port(DHT11_CLK,DHT11_RESET:in std_logic;		--DHT11_CLK:781250Hz(50MHz/2^6:1.28us:FD(5))操作速率,重置
		 DHT11_D_io:inout std_logic;				--DHT11 i/o
		 DHT11_DBo:out std_logic_vector(7 downto 0);--DHT11_driver 資料輸出
		 DHT11_RDp:in integer range 0 to 7;			--資料讀取指標
		 DHT11_tryN:in integer range 0 to 7;		--錯誤後嘗試幾次
		 DHT11_ok,DHT11_S:buffer std_logic;			--DHT11_driver完成作業旗標,錯誤信息
		 DHT11_DBoH,DHT11_DBoT:buffer integer range 0 to 255;--直接輸出濕度及溫度
		 DHT11_DBoH_8bit,DHT11_DBoT_8bit:buffer std_logic_vector(7 downto 0);
		 DHT11_DBoH1,DHT11_DBoH0,DHT11_DBoT1,DHT11_DBoT0:out integer range 0 to 9);--直接輸出濕度及溫度
end component DHT11_driver;

signal DHT11_CLK,DHT11_RESET:std_logic;
signal DHT11_DBo:std_logic_vector(7 downto 0);
signal DHT11_RDp: integer range 0 to 7;  --資料讀取指標
signal DHT11_tryN:integer range 0 to 7:=3;					-- 失敗重試 3 次
signal DHT11_ok,DHT11_S:std_logic;
signal DHT11_DBoH,DHT11_DboT :std_logic_vector(7 downto 0);
signal DHT11_DBoH_int,DHT11_DBoT_int :integer range 0 to 99;
signal DF:std_logic_vector(17 downto 0);					-- 除頻計數器
signal run:std_logic;										-- 讀取流程時脈
signal delTT:integer ;										-- 兩次讀取間隔倒數

begin
	-- 除頻器
	process(clk,reset)
	begin
		if reset ='0' then
			DF<="000000000000000000";
		elsif clk'event and clk='1' then
				DF<=DF+1;
		end if;
	end process;
	
	DHT11_CLK<=DF(5);		-- 781.25kHz
	run<=DF(15);			-- 約 763Hz
	
	U1:DHT11_driver port map  (
		 DHT11_CLK,DHT11_RESET,		--DHT11_CLK:781250Hz(50MHz/2^6:1.28us:FD(5))操作速率,重置
		 DHT11_D_io,				--DHT11 i/o
		 DHT11_DBo,--DHT11_driver 資料輸出
		 DHT11_RDp,		--資料讀取指標
		 DHT11_tryN,		--錯誤後嘗試幾次
		 DHT11_ok,DHT11_S,		--DHT11_driver完成作業旗標,錯誤信息
		 DHT11_DBoH_int,
		 DHT11_DBoT_int,
		 DHT11_DBoH_8bit=>DHT11_DBoH,
		 DHT11_DBoT_8bit=>DHT11_DBoT
		 );--直接輸出濕度及溫度 )
	
	-- 讀取控制：啟動 driver → 等待完成 → 鎖存結果 → 間隔後重新讀取
	process(run)
	begin
		if reset ='0' then
			DHT11_RESET<='0';
		
		elsif run'event and run ='1' then
			if DHT11_RESET ='0' then			-- 啟動一次讀取
				DHT11_RESET<='1';
				DHT_OK<='0';
				delTT<=1500;
			elsif DHT11_ok ='1' then			-- 讀取完成：鎖存結果
				DHT_OK<='1';
				BoT_int<=DHT11_DBoT_int;
				BoH_int<=DHT11_DBoH_int;
				BOH<=DHT11_DBoH;
				BOT<=DHT11_DBoT;
				delTT<=delTT-1;
				if delTT=0 then					-- 間隔時間到，重新讀取
					
					DHT11_RESET<='0';
				end if;
			end if;
		end if;
		
	end process;
end a;
