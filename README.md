# VHDL_CPT_TEST

本專案收錄多種 VHDL 程式與電路設計範例，從基礎邏輯閘到感測器驅動，適合初學者與進階使用者參考。
每個資料夾都附有 `README.md` 說明，每個 `.vhd` 檔開頭也有檔頭註解 (功能、腳位、運作方式、相依元件)。

---

## 目錄結構

```
VHDL_CPT_TEST
├── base/                      基礎數位邏輯
│   ├── and_not_or.vhd         AND / NOT / OR 組合
│   ├── havecontrol_and_or.vhd 具致能的 AND / OR
│   ├── MUX.vhd / DMUX.vhd     8 對 1 多工器 / 1 對 8 解多工器
│   ├── divider_n.vhd          除 N 除頻器
│   ├── shift_register.vhd     10 位元移位暫存器
│   ├── FA/                    半加器、全加器、3/4 位元加法器
│   ├── SRFF/                  SR 閂鎖器與應用
│   └── bin to bcd/            二進位轉 BCD (3 種寫法)
├── seg7/
│   └── oneseg7/               七段顯示器解碼器 (含消零)
├── Simple_project/
│   ├── Clock.vhd              MM:SS 計時器
│   └── PUF/                   環形振盪器 PUF
└── Sensor And Module/
    ├── DHT11/                 溫濕度感測器 (單線)
    ├── KEY4_4.vhd             4x4 矩陣鍵盤
    ├── LED8X8_R_G/            8x8 LED 點矩陣
    ├── SD178B/                語音播放模組 (I2C)
    ├── ST7735_TFTLCD/         彩色 TFT LCD (SPI)
    ├── TSL2561/               光照度感測器 (I2C)
    └── UART/                  串列收發器
```

## 目錄索引

| 資料夾 | 說明 |
|--------|------|
| [base](./base) | 基礎數位邏輯元件 (AND/OR/NOT、MUX/DMUX、除頻器、移位暫存器、加法器、SR 閂鎖、BCD 轉換) |
| [seg7](./seg7) | 七段顯示器解碼器，供其他專案引用 |
| [Simple_project](./Simple_project) | 結合多個元件的小型專案 (計時器、PUF) |
| [Sensor And Module](./Sensor%20And%20Module) | 各式感測器與模組驅動 (DHT11、SD178B、LED8X8、ST7735、TSL2561、UART、4x4 鍵盤) |

## 建議學習順序

1. `base/` 的組合邏輯 → `MUX` / `DMUX` → `FA` (component 與 generate)
2. `base/divider_n.vhd`、`shift_register.vhd` (時脈與循序邏輯)
3. `seg7/` → `base/SRFF`、`Simple_project/Clock.vhd` (元件例化 + 顯示)
4. `Sensor And Module/` 的 `KEY4_4`、`LED8X8` (掃描) → `UART` → `DHT11` → I2C / SPI 模組

## 共通約定

- 開發環境：Intel (Altera) Quartus，系統時脈多為 **50MHz** (UART 為 11.059MHz)。
- 重置信號大多為 **低態有效** (`reset = '0'` 時重置)。
- 七段顯示器多為 **共陽極** (`'0'` 點亮)，`seg(7 downto 1)` = `abcdefg`、`seg(0)` = 小數點。
- 多數程式使用 `ieee.std_logic_arith` / `ieee.std_logic_unsigned` (Synopsys 套件)。
  使用 GHDL 時需加上 `-fsynopsys`，且部分寫法 (如同時引用 arith 與 unsigned 時的比較運算) 只有 Quartus 能接受。

## 其他說明

- `integer` 與 `std_logic_vector` 型態轉換需使用 `ieee.std_logic_arith.all`
  ```vhdl
  A: integer
  B: std_logic_vector

  A <= conv_integer(B);
  B <= conv_std_logic_vector(A, std_logic_vector range);
  ```

- 有任何問題歡迎於 Issues 區提出，將盡快協助修正與解答。
