//
//  ViewController.swift
//  CurrentcyBitcoinConverter
//
//  Created by practica on 1/11/17.
//  Copyright © 2017 practica. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {

    
    
    @IBOutlet weak var labelPrice: UILabel!
    
    @IBOutlet weak var currencyPickerView: UIPickerView!
    
    let currencyArray = ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","COP","USD","CLP"]
    
    let simbolArray = ["$","$","$","¥","€","£","元","Rp","₪","₹","¥‎","$","xE","$","zł","bani","руб", "COP$", "USD$ ", "CLP$"]
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    
    var finalURL : String?
    var finalSimbol : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
        finalURL = baseURL + currencyArray[row]
        finalSimbol = simbolArray[row]
        getBitcoinData(url: finalURL!)
    }

    //MARK: -Networking
    
    func getBitcoinData(url: String)
    {
        Alamofire.request(url, method: .get).responseJSON{
            (response) in
            if response.result.isSuccess
            {
                let bitcoinJSON : JSON = JSON(response.result.value!)
                self.updateBitcoinData(json: bitcoinJSON)
            }
            else
            {
                print("Error: \(response.result.error)")
                self.labelPrice.text = "Se presentó un problema en la conexión"
            }
        }
    }
    
    
    
    
    
    
    func updateBitcoinData(json: JSON)
    {
        if let bitcoinResult = json["ask"].double{
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            numberFormatter.groupingSeparator = "."
            let formateNumber = numberFormatter.string(from: bitcoinResult as NSNumber)
            labelPrice.text = String(finalSimbol! + " "  + formateNumber!)
        }
        else{
            labelPrice.text = "Servicio no disponible"
        }
    }

}

