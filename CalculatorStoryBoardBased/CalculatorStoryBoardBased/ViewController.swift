//
//  ViewController.swift
//  CalculatorStoryBoardBased
//
//  Created by 김윤홍 on 6/21/24.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var text: UILabel!
  
  @IBAction func button(_ sender: UIButton) {
    guard let buttonTitle = sender.titleLabel?.text else { return }
    var resultLabel = ""
    
    switch buttonTitle {
    case "AC":
      text.text = "0"
      
    case "=":
      if let intValue = calculate(text.text!) {
        text.text = String(intValue)
      } else {
        text.text = "ERROR PRESS AC"
      }
      
    default:
      text.text! += buttonTitle
    }
    text.text = isValidExpression(text.text!)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    text.text = "0"
  }
  
  func isValidExpression(_ label: String) -> String {
    var labelArray = Array(label)
    let labelLength = labelArray.count
    
    if labelArray[0] == "0" && labelArray.count > 1 {
      labelArray.removeFirst()
    }
    
    if labelLength > 2 {
      for index in 0..<labelLength - 1 {
        let currentChar = labelArray[index]
        let nextChar = labelArray[index + 1]
        if "*+-/".contains(currentChar) && "*+-/".contains(nextChar) {
          return "ERROR PRESS AC!"
        }
      }
    }
    let isValid = labelLength >= 3 &&
    !labelArray[labelLength - 3].isNumber &&
    labelArray[labelLength - 2] == "0" &&
    labelArray[labelLength - 1].isNumber
    
    if isValid {
      labelArray.remove(at: labelLength - 2)
    }
    return String(labelArray)
  }
  
  func calculate(_ expression: String) -> Int? {
    let expression = NSExpression(format: expression)
    if let result = expression.expressionValue(with: nil, context: nil) as? Int {
      return result
    } else {
      return nil
    }
  }
}

