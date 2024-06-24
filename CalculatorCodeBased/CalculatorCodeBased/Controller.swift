//
//  Controller.swift
//  CalculatorCodeBased
//
//  Created by 김윤홍 on 6/23/24.
//
import Foundation

class Calculator {
  enum CaluculateError: Error {
    case multipleOperatorsError
    case startingZeroError
  }
  
  func isValidExpression(_ label: String) throws -> Bool {
    let labelArray = Array(label)
    var text = ""
    var index = 0
    
    while index < labelArray.count {
      while index < labelArray.count && labelArray[index].isNumber {
        text += String(labelArray[index])
        index += 1
      }
      
      if text.first == "0" && text.count > 1 {
        throw CaluculateError.startingZeroError
      }
      
      if index < labelArray.count - 1 {
        let currentChar = labelArray[index]
        let nextChar = labelArray[index + 1]
        if "*+-/".contains(currentChar) && "*+-/".contains(nextChar) {
          throw CaluculateError.multipleOperatorsError
        }
      }
      text = ""
      index += 1
    }
    return true
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
