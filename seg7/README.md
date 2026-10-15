# seg7 — 七段顯示器

本資料夾收錄七段顯示器解碼器，可被其他專案 (例如 [`Simple_project/Clock.vhd`](../Simple_project/Clock.vhd)、[`base/SRFF`](../base/SRFF)) 當作元件使用。

## oneseg7 (單顆七段顯示器)

| 檔案 | 輸入 | 說明 |
|------|------|------|
| `oneseg7/seg7.vhd` | 4 bit BCD (0~9) + `dot` | 共陽極 (低態點亮) 解碼器，含小數點與消零 (RBI/RBO) |
| `oneseg7/seg7_0to7_haveRBI_O.vhd` | 3 bit (0~7) | 共陽極解碼器，小數點固定熄滅，含消零 |

### 輸出格式

`seg(7 downto 0)` = `a b c d e f g dp`，`'0'` 表示點亮 (共陽極)。

```
   a
 f   b
   g
 e   c
   d   dp
```

### 消零 (Ripple Blanking)

- `RBI = '0'` 且輸入為 0 時，該位數全滅，用來去除前導 0 (例如 `07` 顯示成 ` 7`)。
- `RBO` 在被消零時輸出 `'0'`，可串接給下一位數的 `RBI`。

### 已知問題

- `seg7_0to7_haveRBI_O.vhd` 的 `RBO` 判斷式把 3 位元 `bcd` 與 `"0000"` (4 位元) 比較，永遠不成立，因此 `RBO` 恆為 `'1'`；如需使用請改為 `bcd = "000"`。
