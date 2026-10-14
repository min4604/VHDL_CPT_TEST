# FA — 加法器 (Full Adder)

本資料夾收錄半加器、全加器以及多位元加法器的 VHDL 範例，可比較 **結構描述 (component 串接)** 與 **行為描述 (直接使用 `+`)** 的差異。

## 檔案說明

| 檔案 | 頂層 entity | 說明 |
|------|-------------|------|
| `FA_1bit.vhd` | `FA_1bit` | 以 2 個半加器 (`halfadder`) + 1 個 OR 閘 (`or_2`) 組成 1 位元全加器 |
| `FA_3bit.vhd` | `FA_3bit` | 內含 1 位元全加器 `FA`，以 `for ... generate` 串接成 3 位元漣波進位加法器 |
| `FA_4bit_by_1bitFA.vhd` | `FA_4bit_by_1bitFA` | 同上，串接 4 個 `FA` 成 4 位元加法器 |
| `FA_4bit.vhd` | `FA_4bit` | 4 位元加法器行為描述：`LED <= ('0'&A) + B` |

## 腳位說明

| 埠 | 方向 | 說明 |
|----|------|------|
| `A`, `B` | in | 加數 (3 或 4 位元，可接指撥開關) |
| `LED` | out | 結果；最高位元為進位 (例：4 位元版 `LED(4)` 為進位) |

## 全加器真值

```
sum   = a XOR b XOR c_in
c_out = (a AND b) OR ((a XOR b) AND c_in)
```

## 注意事項

- `FA_3bit.vhd` 與 `FA_4bit_by_1bitFA.vhd` 都定義了名為 `FA` 的 entity，**不要同時加入同一個 Quartus 專案**，否則會出現重複定義錯誤。
- 檔名原本為 `FA_4bit_by_1bitFA .vhd` (含空白)，已更正為 `FA_4bit_by_1bitFA.vhd`。
- 若需要更多位元，只要調整 `generate` 的範圍及向量寬度即可。
