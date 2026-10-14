-------------------------------------------------------------------
-- 檔案名稱：SR_application.vhd
-- 功    能：SR 閂鎖器應用 —— 馬達開關 + 2 位數 BCD 啟動次數計數器
-- 說    明：
--   button(2) (S) : 啟動馬達 (LED 亮)
--   button(1) (R) : 停止馬達 (LED 滅)
--   button(0)     : 將計數器清為 00 (低態動作)
--   sw            : 按鍵致能，sw='1' 時按鍵才有效
--   每當馬達由 OFF → ON (Q 上升緣) 時，BCD 計數器加 1 (00~99)，
--   個位數顯示於 seg1，十位數顯示於 seg2 (十位數 0 時不顯示)。
-- 相依元件：SR_byNAND.vhd、seg7 (七段顯示解碼器)
-- 注    意：此處 seg7 component 沒有 dot 腳位；
--           若使用 seg7/oneseg7/seg7.vhd，需在 component 及 port map 補上 dot。
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity SR_application is
port(	button 		:in  std_logic_vector(2 downto 0);	-- 2:S 1:R 0:計數清除
		sw 	   		:in  std_logic;						-- 按鍵致能
		seg1,seg2	:out std_logic_vector(7 downto 0); --seg1 LSB seg2 MSB
		LED			:out std_logic						-- 馬達狀態 (Q)
	);
end SR_application;

architecture a of SR_application is

component SR_byNAND
port(	S,R,En:in std_logic;
		Q:buffer std_logic
	);
end component;

component seg7
port(	bcd : in  std_logic_vector(3 downto 0);
			RBI : in  std_logic;
			RBO : out std_logic;
			seg : out std_logic_vector(7 downto 0)
		);
end component;

signal conter_Lsb,conter_Msb:std_logic_vector(3 downto 0):="0000";	-- 個位、十位 BCD
signal Q:std_logic;													-- 馬達狀態

begin
	SR1:SR_byNAND port map(button(2),button(1),sw,Q);
	LED<=Q;

	-- 2 位數 BCD 計數器：以 Q 的上升緣 (馬達啟動) 計數
	process(Q)
	begin
		if (sw and button(0))='0' then		-- 非同步清除
			conter_Lsb<=(others=>'0');
			conter_Msb<=(others=>'0');
		elsif Q'event and Q='1' then
			if conter_Lsb="1001" then		-- 個位數到 9 → 歸 0 並進位
				conter_Lsb<=(others=>'0');
				if conter_Msb ="1001" then	-- 十位數到 9 → 歸 0
					conter_Msb<=(others=>'0');
				else
					conter_Msb<=conter_Msb+1;
				end if;
			else
				conter_Lsb<=conter_Lsb+1;
			end if;
		end if;
	end process;

	-- 七段顯示：個位數永遠顯示 (RBI='1')，十位數為 0 時消隱 (RBI='0')
	segA:seg7 port map( bcd=>conter_Lsb,
						RBI=>'1',
						seg=>seg1);
	segB:seg7 port map( bcd=>conter_Msb,
						RBI=>'0',
						seg=>seg2);
	
	
end a;
