-------------------------------------------------------------------
-- 檔案名稱：FA_3bit.vhd
-- 功    能：3 位元漣波進位加法器 (Ripple Carry Adder)，結果顯示於 LED
-- 說    明：本檔包含兩個 entity：
--   1. FA      : 1 位元全加器 (直接用布林式描述)
--   2. FA_3bit : 以 for-generate 例化 3 個 FA 串接
--   LED(2 downto 0) 為和，LED(3) 為最高位進位。
-- 注    意：FA_4bit_by_1bitFA.vhd 內也定義了同名 entity "FA"，
--           兩檔不要同時加入同一個專案，否則會有重複定義。
-------------------------------------------------------------------

-- ===== 1 位元全加器 =====
library ieee;
use ieee.std_logic_1164.all;
entity FA is
port(	a, b, c_in : in STD_LOGIC;		-- 加數 a、b 與進位輸入
		c_out, sum : out STD_LOGIC);	-- 進位輸出與和
end FA;

architecture FA_1bit of FA is
begin
c_out <=((a xor b) and c_in) or (a and b);	-- 進位
sum <= (a xor b) xor c_in;					-- 和
end FA_1bit;


-- ===== 頂層：3 位元加法器 =====
library ieee ;
use ieee.std_logic_1164.all;

entity FA_3bit is
port(	A,B :in  std_logic_vector(2 downto 0);	-- 兩個 3 位元加數
		LED :out std_logic_vector(3 downto 0)	-- 4 位元結果 (含進位)
	);
end FA_3bit;

architecture FAdd of FA_3bit is

component FA 
port(	a, b, c_in : in STD_LOGIC;
		c_out, sum : out STD_LOGIC);
end component;
signal c:std_logic_vector(3 downto 0):="0000";	-- 進位鏈，c(0) 為最低位進位輸入 (固定 0)
signal A1,B1,sum:std_logic_vector(3 downto 1);	-- 索引改為 3~1，方便與 generate 的 i 對應
begin
	A1<=A;
	B1<=B;
	-- 第 i 個全加器：輸入 c(i-1)，輸出 c(i)
	adders:
	for i in 1 to 3 generate
		adder:FA port map(A1(i),B1(i),c(i-1),c(i),sum(i));
	end generate adders;
	led(2 downto 0)<=sum;
	LED(3)<=c(3);		-- 最高位進位
end FAdd;
