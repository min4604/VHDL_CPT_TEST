# TSL2561 — 數位光照度感測器 (I2C)

TSL2561 內含兩個光二極體：CH0 (可見光 + 紅外) 與 CH1 (紅外)，透過兩者比例換算出人眼感受的照度 (Lux)。
資料手冊請見 `TSL2561_datasheet.pdf`。

## 檔案說明

| 檔案 | 說明 |
|------|------|
| `TSL2561.vhd` | 頂層：週期性開機 → 設定 → 讀取 CH0/CH1 → 關機，並依 datasheet 整數演算法計算 Lux |
| `i2c2wdriver2.vhd` | 通用 I2C 主控端驅動 (YHGL V13 版，也可用於 24LCxx EEPROM) |

## TSL2561.vhd 介面

| 埠 | 方向 | 說明 |
|----|------|------|
| `clk50M`, `reset_in` | in | 50MHz 時脈、低態重置 |
| `TSL2561_SCL` | out | I2C SCL |
| `TSL2561_SDA` | inout | I2C SDA (需上拉電阻) |
| `int_out` | out | 量測週期 / 模擬中斷信號 (觀察用) |
| `dtout` | out | 照度值 (lux，整數) |

## I2C 位址

`ID & A2A1A0` = `0111` & `001` = **0x39** (ADDR SEL 腳浮接)。
ADDR SEL 接 GND 為 0x29、接 VDD 為 0x49，需同時修改 `TSL2561_ID`。

## Lux 計算流程

1. `CH0`、`CH1` 依積分時間 (`Tint`) 與增益 (`iGain`) 乘上 `chScale`
2. `ratio = CH1 / CH0`
3. 依 `ratio` 查表取得係數 `B`、`M` (依封裝 `iType` 選擇 T/FN/CL 或 CS 表)
4. `lux = (CH0 × B − CH1 × M) / 2^14`

預設：`iGain = 0` (1x)、`Tint = 2` (402ms)、`iType = 0` (T/FN/CL 封裝)。
