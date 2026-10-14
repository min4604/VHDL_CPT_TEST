-------------------------------------------------------------------
-- 檔案名稱：SR_byNAND.vhd
-- 功    能：以 NAND 閘構成、具致能 (En) 的 SR 閂鎖器 (Gated SR Latch)
-- 說    明：
--   S、R 為「低態動作」(按鍵按下 = '0')，方便直接接開發板上的按鈕。
--     En='0'          : 保持 (Q 不變)
--     En='1', S='0'   : 設定 Q='1'
--     En='1', R='0'   : 重置 Q='0'
--     En='1', S=R='1' : 保持
--   Q_buf 與 Qn 互相交叉回授，形成記憶功能。
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity SR_byNAND is
port(	S,R,En:in std_logic;	-- S:設定(低態) R:重置(低態) En:致能
		Q:out std_logic			-- 閂鎖輸出
	);
end SR_byNAND ;

architecture SRFF of SR_byNAND is
signal Qn ,Q_buf:std_logic;		-- Qn:反相輸出, Q_buf:Q 的內部回授
begin
	Q_buf <=((not S) nand En) nand Qn;	-- 上半部 NAND
	Qn<=((not R) nand En) nand Q_buf;	-- 下半部 NAND
	q<=Q_buf;
end SRFF;
