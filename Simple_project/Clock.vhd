-------------------------------------------------------------------
-- 檔案名稱：Clock.vhd
-- 功    能：分:秒 (MM:SS) 計時器，以 4 顆七段顯示器顯示
-- 說    明：
--   1. DF 為 25 位元除頻計數器，以 DF(25) 作為計時時脈
--      (50MHz / 2^25 ≒ 1.49Hz，約 0.67 秒跳一次；
--       若需精確 1 秒，可改用 divider_n 以 N=50,000,000 除頻)。
--   2. MMSS(0)=秒個位、MMSS(1)=秒十位、MMSS(2)=分個位、MMSS(3)=分十位，
--      依 9 → 5 → 9 → 5 進位，59:59 後回到 00:00。
--      初始值為 34:56 (方便觀察進位)。
--   3. 每一位數透過 seg7 元件解碼後輸出到 Hex1~Hex4 (小數點熄滅)。
-- 相依元件：seg7/oneseg7/seg7.vhd
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Clock is
port (	ck_50M				: in  std_logic;					-- 系統時脈 50MHz
		Hex1,Hex2,Hex3,Hex4	: out std_logic_vector(7 downto 0)	-- 秒個位/秒十位/分個位/分十位
	 );
end Clock;

architecture a of Clock is
component seg7
port(	bcd : in  std_logic_vector(3 downto 0);
			dot : in  std_logic;
			RBI : in  std_logic;
			RBO : out std_logic;
			seg : out std_logic_vector(7 downto 0)
		);
end component;
type MMSS_array is array(3 downto 0) of std_logic_vector(3 downto 0);
signal MMSS :MMSS_array:=("0011","0100","0101","0110");		-- 初始 34:56 (3,4,5,6)
signal DF: std_logic_vector(25 downto 1):=(others =>'0');	-- 除頻計數器

begin
	-- 除頻器
	process(ck_50M)
	begin
		if ck_50M'event and ck_50M ='1' then
			DF<=DF+1;
		end if;
	end process;
	
	-- 計時：秒個位(0~9) → 秒十位(0~5) → 分個位(0~9) → 分十位(0~5)
	process(DF(25))
	begin
		if DF(25)'event and DF(25) = '1' then
			if MMSS(0) ="1001" then
				MMSS(0)<="0000";
				if MMSS(1) = "0101" then
					MMSS(1)<="0000";
					if MMSS(2) = "1001" then
						MMSS(2) <= "0000" ;
						if MMSS(3) = "0101" then
							MMSS(3) <="0000";
						else
							MMSS(3) <= MMSS(3) +1;
						end if;
					else
						MMSS(2)<=MMSS(2)+1;
					end if;
				else
					MMSS(1) <= MMSS(1)+1;
				end if;
			else
				MMSS(0) <= MMSS(0) +1;
			end if;
		end if;
	end process;
	-- 七段顯示器 (dot='1' 熄滅小數點，RBI='1' 不消零)
	segA:seg7 port map( bcd=>MMSS(0),dot=>'1',RBI=>'1',seg=>Hex1 );
	segB:seg7 port map( bcd=>MMSS(1),dot=>'1',RBI=>'1',seg=>Hex2 );
	segC:seg7 port map( bcd=>MMSS(2),dot=>'1',RBI=>'1',seg=>Hex3 );
	segD:seg7 port map( bcd=>MMSS(3),dot=>'1',RBI=>'1',seg=>Hex4 );
end a;
			
	
