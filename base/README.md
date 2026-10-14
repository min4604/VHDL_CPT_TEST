# base — 基礎數位邏輯

本資料夾收錄基礎數位邏輯元件的 VHDL 範例，適合初學者練習組合邏輯、循序邏輯與元件例化 (component / port map)。

## 檔案說明

| 檔案 | 類型 | 功能 |
|------|------|------|
| `and_not_or.vhd` | 組合邏輯 | `D = (A AND B) OR (NOT C)`，示範 `buffer` 埠 |
| `havecontrol_and_or.vhd` | 組合邏輯 | 具低態致能 `C` 的 AND / OR 閘 (使用 `BIT` 型態) |
| `MUX.vhd` | 組合邏輯 | 8 對 1 多工器 (`with ... select`) |
| `DMUX.vhd` | 組合邏輯 | 1 對 8 解多工器 (聚合 `others=>'0'` 寫法) |
| `divider_n.vhd` | 循序邏輯 | 通用除 N 除頻器，以 `generic N` 設定倍數 |
| `shift_register.vhd` | 循序邏輯 | 10 位元可載入 / 左移 / 右移暫存器，LED 顯示 |

## 子資料夾

| 資料夾 | 內容 |
|--------|------|
| [FA](./FA) | 半加器、全加器，3 / 4 位元加法器 (結構描述 vs 行為描述) |
| [SRFF](./SRFF) | NAND 構成的 SR 閂鎖器及「馬達開關 + 計數器」應用 |
| [bin to bcd](./bin%20to%20bcd) | 二進位轉 BCD：移位加三法、連續減法法、七段顯示 |

## 備註

- `MUX.vhd`、`DMUX.vhd`、`shift_register.vhd` 的 `case` / `with select` 沒有 `when others`。
  Quartus 可以編譯，但 GHDL 等嚴格的工具會回報 *missing choice*，必要時可自行補上。
- 檔名原本含有空白 (`havecontrol_and_or .vhd`)，已更正為 `havecontrol_and_or.vhd`。
