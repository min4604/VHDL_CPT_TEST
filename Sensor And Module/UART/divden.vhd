-------------------------------------------------------------------
-- 檔案名稱：divden.vhd
-- 功    能：任意偶數除頻器 (50% 工作週期)
-- 說    明：
--   每計數 N/2 個輸入時脈就反相一次輸出，因此 clkout = Pinclk / N。
--   UART 中以 N=6 將 11.059MHz 除為 1.8432MHz，供鮑率產生器使用。
--   rst='0' 時非同步重置。
-------------------------------------------------------------------
--任意除頻器
--假設輸入11.059MHz頻率,可任意除N倍頻率 N=6頻率=1.8432MHz  
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity divden is 
generic(N:integer :=6);--除N=6倍頻率 
port (
       Pinclk,rst:in  std_logic;	-- 輸入時脈、低態重置
       clkout    :out  std_logic	-- 除頻輸出
      );
end divden;
architecture a of divden is
signal clktemp :std_logic;
signal cnt:integer range 1 to N/2;--N/2計數反相輸出訊號
begin
  process(Pinclk,rst)
    begin
      if rst='0' then
        cnt<=1;
        clktemp<='0';
      elsif Pinclk'event and Pinclk='1'then
        if cnt=N/2 then         --
           cnt<=1;
           clktemp<=not clktemp;
        else
           cnt<=cnt+1;
        end if;
      end if;
      clkout<=clktemp;
   end process;
   
end a;
