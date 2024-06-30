//
//  Controller.swift
//  CalculatorCodeBased
//
//  Created by 김윤홍 on 6/23/24.
//
import Foundation

class Calculator {
  
  //입력된 문자열 유효성 검사
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
  
  //계산
  func calculate(_ expression: String) -> Int? {
    if expression.count < 2 || !expression.last!.isNumber {
      return nil
    }
    let expression = NSExpression(format: expression)
    if let result = expression.expressionValue(with: nil, context: nil) as? Int {
      return result
    } else {
      return nil
    }
  }
}
