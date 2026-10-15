# PUF — 環形振盪器物理不可複製函數

PUF (Physical Unclonable Function) 利用每顆晶片製程上的微小差異產生獨一無二的「指紋」。
本範例比較兩個環形振盪器 (Ring Oscillator, RO) 的頻率，由比較結果產生 1 位元回應。

## 架構

```
          ┌─ RO(7)  ─┐
          ├─ RO(9)  ─┤        ┌─ MUX8_1_a ─ clk_a ─ calculate_frequencies ─ nHz_a ─┐
 res ────►├─  ...   ─┼─clk_Ring┤                                                   ├─ comparator ─► LED
          └─ RO(21) ─┘        └─ MUX8_1_b ─ clk_b ─ calculate_frequencies ─ nHz_b ─┘
                                   ▲  sw (challenge)          ▲ clk_1Hz (divider_n)
```

1. 8 組不同階數 (7, 9, 11, …, 21) 的環形振盪器持續振盪。
2. 挑戰值 `sw` 同時送進兩個多工器；兩個多工器的輸入排列不同，因此會選到兩個不同的振盪器。
3. 兩個頻率計在 1 秒內分別計數振盪器週期數。
4. 比較器輸出 `nHz_a > nHz_b`，即為 PUF 回應 `LED`。

## 檔案說明

| 檔案 | 說明 |
|------|------|
| `PUF.vhd` | 頂層 |
| `Ring_OScillator_n.vhd` | N 階環形振盪器 (`generic n`，須為奇數)，`EN` 控制啟停 |
| `MUX8_1.vhd` | 8 對 1 多工器 |
| `calculate_frequencies.vhd` | 頻率計：以 1Hz 閘門計數 1 秒內的週期數 |
| `comparator.vhd` | `WIDTH` 位元無號數比較器 |
| `divider_n.vhd` | 除 N 除頻器，此處將 50MHz 除為 1Hz |

## 腳位

| 埠 | 方向 | 說明 |
|----|------|------|
| `clk_50M` | in | 系統時脈 50MHz |
| `res` | in | 低態重置，同時作為振盪器致能 |
| `sw[2:0]` | in | 挑戰值 (challenge) |
| `LED` | out | 回應位元 (response) |
| `Ring_OScillator_out[1:0]` | out | 7 階與 21 階振盪器輸出，可接示波器觀察 |

## 注意事項

- 環形振盪器是組合迴路，合成時會出現 combinational loop 警告，屬於預期行為；`syn_keep` 屬性用來避免反相器鏈被最佳化掉。
- 一般 RTL 模擬沒有閘延遲，振盪器不會正常振盪，需在實際 FPGA 上觀察結果。
- `MUX8_1.vhd` 的 `with select` 沒有 `when others`，GHDL 會回報 *missing choice*。
