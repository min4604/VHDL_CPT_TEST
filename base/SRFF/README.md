# SRFF — SR 閂鎖器

## 檔案說明

| 檔案 | 說明 |
|------|------|
| `SR_byNAND.vhd` | 以 NAND 閘構成、具致能 `En` 的 SR 閂鎖器。`S`、`R` 為低態動作，可直接接開發板按鈕 |
| `SR_application.vhd` | 應用範例：以 SR 閂鎖器控制「馬達」開關，並以 2 位數 BCD 計數器統計啟動次數 |

## SR_byNAND 功能表

| En | S | R | Q |
|----|---|---|---|
| 0 | x | x | 保持 |
| 1 | 0 | 1 | 1 (設定) |
| 1 | 1 | 0 | 0 (重置) |
| 1 | 1 | 1 | 保持 |

## SR_application 腳位功能

- `button(2)` (S)：啟動馬達 (`LED` = Q 亮)
- `button(1)` (R)：停止馬達 (`LED` 滅)
- `button(0)`：將 2 位數 BCD 計數器清為 00
- `sw`：按鍵致能，`sw='1'` 時按鍵才有效，否則全部按鍵無效
- `seg1` / `seg2`：顯示計數器的個位 / 十位 (十位為 0 時不顯示)
- 每當馬達由 OFF → ON (Q 上升緣)，計數器加 1 (00 ~ 99)

> English summary: PushButton2 (S) turns the motor on, PushButton1 (R) turns it off,
> PushButton0 resets the 2-digit BCD counter, SW0 enables the buttons, and the counter
> advances on every OFF→ON transition of the motor.

## 相依元件

- `SR_byNAND.vhd`
- `seg7` 七段顯示解碼器：此處的 component **沒有 `dot` 腳位**；
  若使用 [`seg7/oneseg7/seg7.vhd`](../../seg7/oneseg7/seg7.vhd)，需在 component 宣告與 port map 補上 `dot`。
