# iOS_MQTT_Dashboard - MQTT溫濕度顯示器
![image](https://upload.cc/i1/2018/07/02/jQ7eMt.gif)
## :pencil2: 概述

顯示溫濕度的iOS應用程式，本程式屬於微型物聯網(IoT)架構實驗的一環。

詳見系列文章: 
  + **[iOS x IoT (1) — Overview](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/ios-x-iot-1-overview-add874221174)**
  + **[iOS x IoT (2) — MQTT 簡介](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/ios-x-iot-2-mqtt-%E7%B0%A1%E4%BB%8B-e750aa420162)**
  + **[iOS x IoT (3) — 建立雲端 Server](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/ios-x-iot-3-%E5%BB%BA%E7%AB%8B%E9%9B%B2%E7%AB%AF-server-449a5b69ad71)**
  + **[iOS x IoT (4) — 建立 MQTT Broker](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/ios-x-iot-4-%E5%BB%BA%E7%AB%8B-mqtt-broker-d86fa8f34dc8)**
  + **[iOS x IoT (5) — Arduino Uno + ESP8266 + DHT-22](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/ios-x-iot-5-arduino-uno-esp8266-dht-22-6f4c65e498ed)**
  + **[iOS x IoT (6) — iOS 溫濕度顯示器 & 總結](https://medium.com/@Syashin/ios-x-iot-6-ios-%E6%BA%AB%E6%BF%95%E5%BA%A6%E9%A1%AF%E7%A4%BA%E5%99%A8-%E7%B8%BD%E7%B5%90-8034f4ed780e)**

## :closed_book: 特色
  + 使用 [CocoaMQTT](https://github.com/emqtt/CocoaMQTT)，接收從 MQTT Broker 傳來的溫濕度資料。
  + 使用 [Carthage](https://github.com/Carthage/Carthage)，當做**第三方套件管理工具**。
  + 注意：本範例需搭配 **MQTT Broker** 與 **Arduino 實體裝置**，方能正確顯示數值，否則數值永遠都是 **Ｎ/A**。
  + 整體專案架構圖(含 Broker、Arduino)：

  ![image](https://upload.cc/i1/2018/07/02/xYEaT5.png)

## :green_book: 安裝專案
1. 本範例使用 [Carthage](https://github.com/Carthage/Carthage) 做套件管理，請先確認是否已安裝，若未安裝，建議使用 **Homebrew** 指令：

        brew update
        brew install carthage
 
2. Clone / Download 這個專案：
  ![image](https://upload.cc/i1/2018/07/03/OCuJ37.png)

3. 打開終端機 Terminal，移動到專案資料夾底下(與 Cartfile 同層)，輸入：
  
        carthage update 
    
   來安裝需要的 Packages。
   ![image](https://upload.cc/i1/2018/07/03/oGcerp.png)

4. 連續出現三次密碼確認畫面，請輸入自己電腦的密碼：
   ![image](https://upload.cc/i1/2018/07/03/jCtLHc.png)

5. 等待安裝完成：

   ![image](https://upload.cc/i1/2018/07/03/7Vpe3h.png)

## :blue_book: 使用方法
1. 執行後，輸入 Topic，按下 Subscribe：

![image](https://upload.cc/i1/2018/07/03/YsPBAL.png)

2. 如果 MQTT Broker 正確運行 & Arduino 裝置已啟動，就能收到即時數值。

![image](https://upload.cc/i1/2018/07/03/WZc0ns.png)

## :orange_book: 其它參考

**Arduino** 程式連結：**[MQTT_DHT22.h](https://gist.github.com/rf777rf777/109d95563d16a341ad1e58466ca51686)**

## :books: Library or API Reference

[CocoaMQTT](https://github.com/emqtt/CocoaMQTT)

## :memo: License
[MIT](https://zh.wikipedia.org/wiki/MIT%E8%A8%B1%E5%8F%AF%E8%AD%89)

