-------------------------------------------------------------------
-- 檔案名稱：PUF.vhd
-- 功    能：環形振盪器 PUF (Ring Oscillator Physical Unclonable Function) 頂層
-- 說    明：
--   PUF 利用每顆 FPGA 製程上的微小差異，產生無法複製的「晶片指紋」。
--   架構：
--     1. 8 組不同階數 (7,9,...,21) 的環形振盪器 → clk_Ring(0~7)
--     2. 兩個 8 對 1 多工器 MUX8_1_a / MUX8_1_b，以相同的挑戰值 sw
--        選出兩個「不同」的振盪器 (兩個 MUX 的輸入排列不同)
--     3. 兩個頻率計在 1 秒內分別計算選中振盪器的頻率
--     4. 比較器比較兩者：頻率 a > b 時 LED='1'，即 PUF 回應位元
--   挑戰 (challenge)：sw(2 downto 0)；回應 (response)：LED
--   res：低態重置兼振盪器致能 (res='0' 時振盪器停止)
-- 相依元件：Ring_OScillator_n、MUX8_1、calculate_frequencies、
--           comparator、divider_n
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PUF  is
port( 	clk_50M	: in	std_logic;						-- 系統時脈 50MHz
		res 	: in 	std_logic;						-- 低態重置 / 振盪器致能
		sw 		: in 	std_logic_vector(2 downto 0);	-- 挑戰值 (challenge)
		LED		: out	std_logic;						-- 回應位元 (response)
		Ring_OScillator_out: out std_logic_vector(1 downto 0)	-- 觀察用：7 階與 21 階振盪器輸出

	);
end PUF;

architecture a of PUF is

component Ring_OScillator_n
generic(n:integer :=31);--N階環形震盪
port( 	EN 		: in 	std_logic;
		ck_out	: out  	std_logic

	);
end component;

component MUX8_1
port (
    I0,I1,I2,I3,I4,I5,I6,I7    	: in  std_logic;
    S    						: in  std_logic_vector(2 downto 0);
    F 							: out std_logic);
end component;

component calculate_frequencies
port( 	res 	: in  std_logic;
		clk_1Hz : in  std_logic;
		clk_nHz	: in  std_logic;
		nHz 	: out std_logic_vector(63 downto 0)

	);
end component;

component comparator
generic (WIDTH : integer := 64);
port (
		val_a    : in  std_logic_vector(WIDTH-1 downto 0);
		val_b    : in  std_logic_vector(WIDTH-1 downto 0);
		solution : out std_logic
	);
end component;

component divider_n
generic(N:integer:=50000000);--Clk_in/Clk_out=N
port(	Clk_50M       :in std_logic;
		Clk_out       :out std_logic
	);
end component;

signal clk_Ring 	:std_logic_vector(7 downto 0);		-- 8 個環形振盪器輸出
signal nHz_a,nHz_b	:std_logic_Vector(63 downto 0);		-- 兩路量測到的頻率
signal clk_a,clk_b,clk_1Hz	:std_logic;					-- 被選中的兩路振盪器、1Hz 閘門時脈
begin
	Ring_OScillator_out<=clk_Ring(0)&clk_Ring(7);

	-- 50MHz → 1Hz
	divider_50000000	:divider_n
	generic	map(N=>50000000)
	port	map(clk_50M,clk_1Hz);

	-- ===== 8 組環形振盪器 (階數皆為奇數) =====
	Ring_OScillator_7		:Ring_OScillator_n
	generic	map(n=>7) 
	port	map(res,clk_Ring(0));
	
	Ring_OScillator_9		:Ring_OScillator_n
	generic	map(n=>9) 
	port	map(res,clk_Ring(1));
	
	Ring_OScillator_11		:Ring_OScillator_n
	generic	map(n=>11) 
	port	map(res,clk_Ring(2));
	
	Ring_OScillator_13		:Ring_OScillator_n
	generic	map(n=>13) 
	port	map(res,clk_Ring(3));
	
	Ring_OScillator_15		:Ring_OScillator_n
	generic	map(n=>15) 
	port	map(res,clk_Ring(4));
	
	Ring_OScillator_17		:Ring_OScillator_n
	generic	map(n=>17) 
	port	map(res,clk_Ring(5));
	
	Ring_OScillator_19		:Ring_OScillator_n
	generic	map(n=>19) 
	port	map(res,clk_Ring(6));
	
	Ring_OScillator_21		:Ring_OScillator_n
	generic	map(n=>21) 
	port	map(res,clk_Ring(7));

	-- ===== 兩個多工器：相同 sw 會選到不同的振盪器 =====
	--01010010
	MUX8_1_a				:MUX8_1
	port	map(clk_Ring(0),clk_Ring(2),clk_Ring(1),clk_Ring(7),clk_Ring(4),clk_Ring(5),clk_Ring(6),clk_Ring(3),sw,clk_a);
	
	MUX8_1_b				:MUX8_1
	port	map(clk_Ring(1),clk_Ring(0),clk_Ring(2),clk_Ring(3),clk_Ring(5),clk_Ring(6),clk_Ring(4),clk_Ring(7),sw,clk_b);

	-- ===== 頻率量測 =====
	calculate_frequencies_a	:calculate_frequencies
	port	map(res,clk_1Hz,clk_a,nHz_a);
	
	calculate_frequencies_b	:calculate_frequencies
	port	map(res,clk_1Hz,clk_b,nHz_b);

	-- ===== 比較頻率 → PUF 回應 =====
	comparator_1		:comparator
	generic	map(WIDTH=>64)
	port	map(nHz_a,nHz_b,Led);
end a;

