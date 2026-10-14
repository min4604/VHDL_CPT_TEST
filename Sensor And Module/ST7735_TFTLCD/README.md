# ST7735_TFTLCD — 1.8 吋彩色 TFT LCD (SPI)

ST7735 驅動的 128x160 TFT LCD，以 4 線 SPI (SCLK、MOSI、CS、DC) 寫入命令與 RGB565 顏色資料。
資料手冊請見 `datasheet.pdf`。

## 檔案說明

| 檔案 | 說明 |
|------|------|
| `TFT_TEST.vhd` | 硬體重置 → 初始化 → 全螢幕填色，每秒輪流切換顏色 |

## 介面

| 埠 | 方向 | 說明 |
|----|------|------|
| `clk_50M`, `reset` | in | 50MHz 時脈、低態重置 |
| `SCLK` | out | SPI 時脈 (模組上標示 SCL) |
| `MOSI` | out | SPI 資料 (模組上標示 SDA) |
| `CS` | out | 晶片選擇 (低態) |
| `DC` | out | `'0'` 命令 / `'1'` 資料 (模組上可能標示 A0 / RS) |
| `RES` | out | 硬體重置 (低態) |
| `LED` | out | 背光 (不接也可以) |

## 程式結構

| procedure | 功能 |
|-----------|------|
| `Write_Cmd` / `Write_Data` | 以 SPI 送出 8 位元命令 / 資料 (MSB 先送) |
| `Write_Data16` | 送出 16 位元顏色資料 |
| `TFT_Init` | ST7735 初始化序列 (軟體重置、離開睡眠、Frame rate、電源、Gamma、16-bit 色彩、開啟顯示) |
| `SetAddressWindow` | 設定繪圖視窗 (欄位址 `2A`、列位址 `2B`、寫入 RAM `2C`)，含模組的 (2,1) 偏移 |
| `FillRectangle` | 以單一顏色填滿矩形 |
| `Count_Data` | 推進 `BITS_CLK` / `BYTE_CLK` 計數，判斷傳送完成 |

## 顏色 (RGB565)

`BLACK 0000`、`BLUE 001F`、`RED F800`、`GREEN 07E0`、`CYAN 07FF`、`MAGENTA F81F`、`YELLOW FFE0`、`WHITE FFFF`

## 注意事項

- 原檔中部分中文註解因編碼 (Big5) 遺失而成為亂碼，已依上下文重新補上。
- procedure 直接驅動架構層級的 signal，Quartus 可以編譯；GHDL 等嚴格依照 VHDL-93 的工具會報錯。
