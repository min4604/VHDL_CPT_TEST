-------------------------------------------------------------------
-- 檔案名稱：divider_n.vhd
-- 功    能：通用除 N 除頻器 (輸出約 50% 工作週期)
-- 說    明：
--   cnt1 在 1 ~ N 之間循環計數，當計數到 N/2 與 N 時各反相一次 cnt2，
--   因此 Clk_out = Clk_in / N。
--   PUF 中以 N = 50,000,000 將 50MHz 除為 1Hz，作為頻率計的閘門時脈。
--   (與 base/divider_n.vhd 相同，只是預設 N 不同)
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity divider_n is
--除N計數器
--Clk_in=50MHZ
--Clk_out=250HZ
generic(N:integer:=50000000);--Clk_in/Clk_out=N
port
(Clk_50M       :in std_logic;		-- 輸入時脈
 Clk_out       :out std_logic);		-- 除頻後輸出時脈
end divider_n;

architecture ARCH of divider_n is
signal cnt2:std_logic;					-- 輸出時脈暫存
begin
	process(Clk_50M)
		variable cnt1:integer range 0 to N:=1;	-- 計數器 1~N
		variable N2:integer range 0 to N; 		-- 半週期計數點
	begin
		N2:=N/2;
		-- 計數 1 ~ N 循環
		if rising_edge(Clk_50M) then
			if cnt1=N then
				cnt1:=1;
			else
				cnt1:=cnt1+1;
			end if;
		end if;
		-- 計數到半週期或整週期時反相輸出
		if rising_edge(Clk_50M)then
			if cnt1=N2 or cnt1=N then
				cnt2<=not cnt2;
			end if;
		end if;
		Clk_out<=cnt2;
	end process;
end ARCH;
