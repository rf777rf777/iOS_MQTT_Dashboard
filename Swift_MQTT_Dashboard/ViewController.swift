//
//  ViewController.swift
//  Swift_MQTT_Dashboard
//
//  Created by Syashin on 2018/6/12.
//  Copyright © 2018年 Syashin. All rights reserved.
//

import UIKit
import CocoaMQTT

//在既有類別CALayer中新增"可同時增加陰影與圓角"的方法
extension CALayer {
    func addShadow(offset:(CGFloat,CGFloat) , opacity:Float ,  radius:CGFloat) {
        self.shadowOffset = .init(width: offset.0, height: offset.1)
        self.shadowOpacity = opacity
        self.shadowRadius = radius
        self.shadowColor = UIColor.black.cgColor
        self.masksToBounds = false
        
        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    func roundCorners(radius: CGFloat) {
        self.cornerRadius = radius
        
        if shadowOpacity != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    private func addShadowWithRoundedCorners() {
        if let contents = self.contents {
            
            masksToBounds = false
            sublayers?.filter{ $0.frame.equalTo(self.bounds) }
                .forEach{ $0.roundCorners(radius: self.cornerRadius) }
            
            self.contents = nil
            
            if let sublayer = sublayers?.first,
                sublayer.name == name {
                
                sublayer.removeFromSuperlayer()
            }
            
            let contentLayer = CALayer()
            contentLayer.name = name
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = cornerRadius
            contentLayer.masksToBounds = true
            
            insertSublayer(contentLayer, at: 0)
        }
    }
}




class ViewController: UIViewController , UITextFieldDelegate {
    
    var mqtt: CocoaMQTT?
    
    var subscribeBool = false
    
    let uiDefaultColor = UIColor.init(red: 167/255, green: 0, blue: 29/255, alpha: 1)
    
    @IBOutlet weak var mqttTopic: UITextField!
    
    @IBOutlet weak var tempTitle: UILabel!
    
    @IBOutlet weak var tempValueLabel: UILabel!
    
    @IBOutlet weak var humTitle: UILabel!
    
    @IBOutlet weak var humValueLabel: UILabel!
    
    @IBOutlet weak var subscribeBtn: UIButton!
    
    @IBOutlet weak var tempView: UIView!
    
    @IBOutlet weak var humView: UIView!
    
    @IBOutlet weak var tempDataReceived: UILabel!
    
    @IBOutlet weak var humDataReceived: UILabel!
    
    @IBOutlet weak var tempImage: UIImageView!
    
    @IBOutlet weak var humImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMQTT()

        subscribeBtn.layer.addShadow(offset: (5,1), opacity: 0.3, radius: 5)
        subscribeBtn.layer.roundCorners(radius: 5)
        
        tempView.layer.addShadow(offset: (1,1), opacity: 1, radius: 7)
        tempView.layer.roundCorners(radius: 5)
        
        humView.layer.addShadow(offset: (1,1), opacity: 1, radius: 7)
        humView.layer.roundCorners(radius: 5)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func subscribeTopic(_ sender: Any) {
        let topic = mqttTopic.text

        if !subscribeBool{
            subscribeBool = true
            mqtt?.subscribe(topic!)
        }
        else{
            subscribeBool = false
            mqtt?.unsubscribe(topic!)
        }
        
        
        mqtt?.didSubscribeTopic = {  mqtt , topic in
            self.subscribeBtn.setTitle("Cancel", for: .normal)
            self.tempView.backgroundColor = UIColor.white
            self.humView.backgroundColor = UIColor.white
            self.tempValueLabel.textColor = UIColor.black
            self.humValueLabel.textColor = UIColor.black
            self.tempTitle.textColor = UIColor.black
            self.humTitle.textColor = UIColor.black
            self.tempDataReceived.textColor = UIColor.black
            self.humDataReceived.textColor = UIColor.black
            self.tempImage.image = UIImage(named: "thermometer")
            self.humImage.image = UIImage(named: "humidity")
        }
        
        mqtt?.didUnsubscribeTopic = { mqtt , topic in
            self.subscribeBtn.setTitle("Subscribe", for: .normal)
            self.tempView.backgroundColor = self.uiDefaultColor
            self.humView.backgroundColor = self.uiDefaultColor
            self.tempValueLabel.textColor = UIColor.white
            self.humValueLabel.textColor = UIColor.white
            self.tempTitle.textColor = UIColor.white
            self.humTitle.textColor = UIColor.white
            self.tempDataReceived.textColor = UIColor.white
            self.humDataReceived.textColor = UIColor.white
            self.tempValueLabel.text = "N/A"
            self.humValueLabel.text = "N/A"
            self.tempDataReceived.text = "No data available"
            self.humDataReceived.text = "No data available"
            self.tempImage.image = UIImage(named: "error")
            self.humImage.image = UIImage(named: "error")
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupMQTT(){
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host: "35.227.109.21", port: 1883)
        mqtt?.autoReconnect = true
        mqtt?.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        mqtt?.keepAlive = 60
        mqtt?.delegate = self as? CocoaMQTTDelegate
        if let mqttStatus = mqtt?.connect(){
            print(mqttStatus)
        }
        
        mqtt?.didReceiveMessage = { mqtt, message, id in
            print("Message received in topic \(message.topic) with payload \(message.string!)")
            let messageData = (message.string)?.data(using: .utf8)
            
            if let data = messageData , let result = try? JSONDecoder().decode(JsonProvider.self, from: data) {
                if let temperature = result.temperature , let humidity = result.humidity{
                    let date = Date()
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: date)
                    let minutes = calendar.component(.minute, from: date)
                    let second = calendar.component(.second, from: date)
                    
                    self.tempDataReceived.text = "\(hour):\(minutes):\(second) Received"
                    self.humDataReceived.text = "\(hour):\(minutes):\(second) Received"
                    
                    self.tempValueLabel.text = "\(temperature)"
                    self.humValueLabel.text = "\(humidity)"
                }
            }
        }
    }
  
}

