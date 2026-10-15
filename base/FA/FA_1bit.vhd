-------------------------------------------------------------------
-- 檔案名稱：FA_1bit.vhd
-- 功    能：以「兩個半加器 + 一個 OR 閘」組成的 1 位元全加器
-- 結    構：
--        x ─┐            ┌─ s1 ─┐
--           ├ halfadder u1┤      ├ halfadder u2 ── sum
--        y ─┘            └─ s3  │        └─ s2
--                            z ─┘
--        carry = s2 OR s3  (or_2 u3)
-- 說    明：本檔包含三個 entity：
--   1. halfadder : 半加器  s = a xor b, c = a and b
--   2. or_2      : 2 輸入 OR 閘
--   3. FA_1bit   : 頂層全加器，以 component 例化上面兩者
-------------------------------------------------------------------

-- ===== 半加器 =====
library ieee;

use ieee.std_logic_1164.all;

entity halfadder is
port(a,b :in std_logic;		-- 兩個加數位元
	 s,c :out std_logic);	-- s:和, c:進位
end halfadder;

architecture a of halfadder is
begin
	s<= a xor b;			-- 和
	c<= a and b;			-- 進位
end a;

-- ===== 2 輸入 OR 閘 =====
library ieee;

use ieee.std_logic_1164.all;

entity or_2 is
port(a,b :in std_logic;
	 c :out std_logic);
end or_2;

architecture a of or_2 is
begin
	
	c<= a or b;
end a;








-- ===== 頂層：1 位元全加器 =====
library ieee;
use ieee.std_logic_1164.all;

entity FA_1bit is
port(x,y,z :in std_logic;				-- x,y:加數, z:前一級進位
	 sum ,carry : out std_logic );		-- sum:和, carry:進位輸出
end FA_1bit;


architecture a of FA_1bit is
component halfadder
port( a,b : in std_logic;
	  s,c : out std_logic );
end component;

component or_2
port( a,b : in std_logic;
	  c : out std_logic );
end component;

signal s1,s2,s3 :std_logic;		-- s1:x xor y, s3:x and y, s2:第二級半加器進位

begin
	u1 :halfadder port map(x,y,s1,s3);		-- 第一級：x + y
	u2 :halfadder port map(s1,z,sum,s2);	-- 第二級：(x xor y) + z
	u3 :or_2      port map(s2,s3,carry);	-- 進位合併
end a;
