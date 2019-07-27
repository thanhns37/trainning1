//
//  ViewController.swift
//  Demo ifelse
//
//  Created by Nguyễn Thành on 11/27/18.
//  Copyright © 2018 Nguyễn Thành. All rights reserved.
//

import UIKit
import UserNotifications
class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var pointTf: UITextField!
    @IBOutlet weak var resultLb: UILabel!
    @IBOutlet weak var midPointTf: UITextField!
    @IBOutlet weak var lastPointTf: UITextField!
    @IBOutlet weak var rankLb: UILabel!
    @IBOutlet weak var testButton: UIButton!
    
    var isValidateDiemGioi: Bool = false
    var isValidateDiemKha: Bool = false
    var alertTitle: String = "THÔNG BÁO"
    var agree: String = "ĐỒNG Ý"
    var message: String = ""
    
    var countMieng: Double = 0
    var countGiuaKy: Double = 0
    var countCuoiKy: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rankLb.text = ""
        resultLb.text = ""
        testButton.layer.cornerRadius = 15
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAlow, error in })
    }
    
    func alert(message: String) {
        let notification = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        notification.addAction(UIAlertAction(title: "Thử lại", style: UIAlertActionStyle.cancel, handler: {_ in}))
        self.present(notification, animated: true, completion: nil)
    }
    

    @IBAction func TestOnclickBtn(_ sender: UIButton) {
        pointTf.resignFirstResponder()
        midPointTf.resignFirstResponder()
        lastPointTf.resignFirstResponder()
        
        let (isOK, msg) = self.validate()
        if !isOK {
            alert(message: msg)
            return
        }
        
        var tb: Double = 0.0
        tb = (tbMieng() + tbGiuaKy() + tbCuoiKy()) / ((countMieng) + (countGiuaKy * 2) + (countCuoiKy * 3))
        let multiplier = pow(10.0, 2.0)
        tb = round(tb * multiplier) / multiplier
        if (tbGiuaKy() + tbCuoiKy()) / ((countGiuaKy * 2) + (countCuoiKy * 3)) > 8 {
            isValidateDiemKha = true
        } else {
            isValidateDiemKha = false
        }
        
        if tb > 8.5 {
            isValidateDiemGioi = true
        } else {
             isValidateDiemGioi = false
        }
        
        if isValidateDiemGioi {
            rankLb.text = "Học Lực Giỏi"
        }
        
        if isValidateDiemKha {
            rankLb.text = "Học Lực Khá"
        }
        
        if !isValidateDiemKha && !isValidateDiemGioi {
            rankLb.text = "Học Lực Trung Bình"
        }
        
        resultLb.text = "\(tb)"
    }
    
    func validate() -> (Bool, String) {
        let replaced1 = pointTf.text!.components(separatedBy: ",")
        let replaced2 = midPointTf.text!.components(separatedBy: ",")
        let replaced3 = lastPointTf.text!.components(separatedBy: ",")
        
        if pointTf.text?.first == "." || pointTf.text?.first == "," || pointTf.text?.last == "," {
            return (false, "Điểm miệng không hợp lệ")
        }

        
        if !pointTf.text!.isEmpty  {
            for item in replaced1 {
                if Double(item)! > 10 {
                    return (false, "Điểm miệng không hợp lệ")
                }
            }
        }
        
        
        if midPointTf.text!.isEmpty {
            return (false, "Bạn phải nhập điểm giữa kỳ")
        }
        
        if midPointTf.text?.first == "." || midPointTf.text?.first == "," || midPointTf.text?.last == "," {
            return (false, "Điểm giữa kỳ không hợp lệ")
        }
  
        if !midPointTf.text!.isEmpty {
            for item in replaced2 {
                if Double(item)! > 10 {
                    return (false, "Điểm giữa kỳ không hợp lệ")
                }
                
            }
        }
        
        
        if lastPointTf.text!.isEmpty {
            return (false, "Bạn phải nhập điểm cuối kỳ")
        }
        
        if lastPointTf.text?.first == "." || lastPointTf.text?.first == "," || lastPointTf.text?.last == "," {
            return (false, "Điểm cuối kỳ không hợp lệ")
        }
        
        if lastPointTf.text!.isEmpty {
            for item in replaced3 {
                if Double(item)! > 10 {
                    return (false, "Điểm cuối kỳ không hợp lệ")
                }
            }
        }
        
        
        return (true, "")
    }
    
    func tbMieng() -> Double {
        countMieng = 0
        var tong: Double = 0.0
        let replaced = pointTf.text!.components(separatedBy: ",")
        for element in replaced {
            tong += Double(element)!
            countMieng += 1
            
            if Double(element)! > 7 && countMieng > 0 {
                isValidateDiemGioi = true
            } else {
                isValidateDiemGioi = false
            }
            
        }
        
        return tong
    }
    
    func tbGiuaKy() -> Double {
        countGiuaKy = 0
        var tong: Double = 0.0
        let replaced = midPointTf.text!.components(separatedBy: ",")
        for element in replaced {
            tong += Double(element)! * 2
            countGiuaKy += 1
            
            if Double(element)! > 7 && countGiuaKy > 1 {
                isValidateDiemGioi = true
            } else {
                isValidateDiemGioi = false
            }
        }
        
        return tong
    }
    
    func tbCuoiKy() -> Double {
        countCuoiKy = 0
        var tong: Double = 0.0
        let replaced = lastPointTf.text!.components(separatedBy: ",")
        for element in replaced {
            tong += Double(element)! * 3
            countCuoiKy += 1
            if Double(element)! > 7 {
                isValidateDiemGioi = true
            } else {
                isValidateDiemGioi = false
            }
        }
        
        return tong
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789,.").inverted
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

