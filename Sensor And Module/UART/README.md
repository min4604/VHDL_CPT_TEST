# UART — 串列收發器

8N1 格式 (1 起始位元、8 資料位元、無同位、1 停止位元) 的 UART 收發器，
輸入時脈為 **11.059MHz**，鮑率由 `sel` 選擇 300 ~ 38400 bps。

## 檔案說明

| 檔案 | 說明 |
|------|------|
| `uart.vhd` | 頂層，連接下列所有元件 |
| `divden.vhd` | 除 N 除頻器，11.059MHz ÷ 6 = 1.8432MHz |
| `br_gen.vhd` | 鮑率產生器，輸出鮑率 `bclk` 與 8 倍鮑率 `bclkx8` |
| `stab_one.vhd` | 單擊脈波產生器，避免按住傳送鍵時重複傳送 |
| `uart_transmitter.vhd` | 傳送器 (狀態機：idle → synch → tdata) |
| `uart_receiver.vhd` | 接收器 (以 8 倍鮑率取樣，於位元中央讀取) |

## 架構

```
sysclk_11_059M ─► divden(÷6) ─► 1.8432MHz ─┬─► br_gen ─┬─ bclk ───► uart_transmitter ─► txd
                                           │           └─ bclkx8 ─► uart_receiver ◄── rxd
txd_start_H ─► stab_one ─► txd_start_plus ─┘
```

## 鮑率選擇 (`sel`，`uart.vhd` 內部信號，預設 `"010"`)

| sel | 鮑率 |
|-----|------|
| 000 | 38400 |
| 001 | 19200 |
| 010 | 9600 |
| 011 | 4800 |
| 100 | 2400 |
| 101 | 1200 |
| 110 | 600 |
| 111 | 300 |

## uart.vhd 介面

| 埠 | 方向 | 說明 |
|----|------|------|
| `sysclk_11_059M` | in | 11.059MHz 時脈 |
| `rst_L` | in | 低態重置 |
| `txd_start_H` | in | 觸發傳送一筆資料 |
| `txd_data_BUS[7:0]` | in | 待傳送資料 |
| `txd` | out | 串列輸出 |
| `txd_down_H` | out | 傳送完成脈波 |
| `rxd` | in | 串列輸入 |
| `rxd_data_BUS[7:0]` | out | 接收到的資料 |
| `rxd_ready_H` | out | 接收完成脈波 |

> 若開發板只有 50MHz 時脈，可用 PLL 產生 11.0592MHz，或修改 `divden` / `br_gen` 的除數。
