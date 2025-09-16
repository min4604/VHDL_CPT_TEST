# VHDL_CPT_TEST

本專案收錄多種 VHDL 程式與電路設計範例，適合初學者與進階使用者參考。  
下列為主要資料夾簡介與快速連結：

---

## 目錄索引

- [base](./base)  
  基礎數位邏輯元件的 VHDL 範例（如 AND/OR/NOT/MUX/DMUX/移位暫存器等），適合邏輯電路基礎學習。

- [Sensor And Module](./Sensor%20And%20Module)  
  各式感測器及模組（如 DHT11 溫濕度、SD178B 聲音播放、LED8X8 點矩陣、UART 等）之 VHDL 驅動與應用範例。

- [Simple_project](./Simple_project)  
  各種簡易 VHDL 專案範例，方便初學者快速實作和練習。

- [seg7](./seg7)  
  七段顯示器相關設計範例（請參考資料夾內說明或程式）。

---

## 其他說明

- `integer` 與 `std_logic_vector` 型態轉換需使用 `ieee.std_logic_arith.all`  
  ```
  A: integer
  B: std_logic_vector

  A <= conv_integer(B);
  B <= conv_std_logic_vector(A, std_logic_vector range);
  ```

- 有任何問題歡迎於 Issues 區提出，將盡快協助修正與解答。