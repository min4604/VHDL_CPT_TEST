-------------------------------------------------------------------
-- 檔案名稱：comparator.vhd
-- 功    能：WIDTH 位元無號數比較器
-- 說    明：val_a > val_b 時 solution='1'，否則為 '0'。
--           PUF 中用來比較兩個環形振盪器的頻率，輸出即為 PUF 回應位元。
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
generic (WIDTH : integer := 64);							-- 資料寬度
port (
		val_a    : in  std_logic_vector(WIDTH-1 downto 0);	-- 比較值 A
		val_b    : in  std_logic_vector(WIDTH-1 downto 0);	-- 比較值 B
		solution : out std_logic							-- A > B ?
	);
end entity comparator;

architecture a of comparator is
begin
  solution <= '1' when (unsigned(val_a) > unsigned(val_b)) else '0';
end  a;
