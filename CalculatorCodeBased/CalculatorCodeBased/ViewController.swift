//
//  ViewController.swift
//  Practice3
//
//  Created by 김윤홍 on 6/21/24.
//

import UIKit

import SnapKit

class ViewController: UIViewController {
  var number = "0"
  var operateCount = 0
  let stackViewVertical = UIStackView()
  let stackViewHorizons: [UIStackView] = {
    let horizontalStackViews = (0..<4).map { _ -> UIStackView in
      let stackView = UIStackView()
      stackView.axis = .horizontal
      stackView.backgroundColor = .black
      stackView.distribution = .fillEqually
      stackView.spacing = 10
      return stackView
    }
    return horizontalStackViews
  }()
  
  let text = UILabel()
  
  let buttons: [UIButton] = {
    let titles = ["7", "8", "9", "+", "4", "5", "6", "-", "1", "2", "3", "*", "AC", "0", "=", "/"]
    return titles.map { title in
      let button = UIButton(type: .system)
      button.setTitle(title, for: .normal)
      if let titleInt = Int(title) {
        button.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1.0)
      } else {
        
        button.backgroundColor = .orange
      }
      button.frame.size.height = 80
      button.frame.size.width = 80
      button.layer.cornerRadius = 40
      button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
      button.setTitleColor(.white, for: .normal)
      return button
    }
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    
    text.text = number
    text.textColor = .white
    text.backgroundColor = .black
    text.font = UIFont.boldSystemFont(ofSize: 60)
    text.textAlignment = .right
    text.adjustsFontSizeToFitWidth = true
    text.minimumScaleFactor = 0.5
    text.numberOfLines = 1
    
    view.addSubview(text)
    view.addSubview(stackViewVertical)
    
    for i in stackViewHorizons {
      stackViewVertical.addArrangedSubview(i)
    }
    
    stackViewVertical.axis = .vertical
    stackViewVertical.backgroundColor = .black
    stackViewVertical.distribution = .fillEqually
    stackViewVertical.spacing = 10
    stackViewVertical.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(text.snp.bottom).offset(60)
      $0.width.equalTo(350)
    }
    
    text.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(30)
      $0.top.equalToSuperview().offset(200)
      $0.height.equalTo(100)
    }
    
    stackViewHorizons[0].snp.makeConstraints {
      $0.height.equalTo(80)
    }
    
    for (index, button) in buttons.enumerated() {
      let stackIndex = index / 4
      stackViewHorizons[stackIndex].addArrangedSubview(button)
      button.addTarget(self, action: #selector(pressedButton), for: .touchUpInside)
    }
    
  }
  
  @objc func pressedButton(_ sender: UIButton) {
    if let title = sender.title(for: .normal) {
      switch title {
      case "AC":
        number = ""
        text.text = "0"
        
      case "=":
        if let result = calculate(expression: number) {
          text.text = String(result)
          number = String(result)
        } else {
          text.text = "0"
        }
        
      default:
        if title == "+" || title == "-" || title == "*" || title == "/" {
          if operateCount > 0 {
            number.removeLast()
          }
          number += String(title)
          operateCount += 1
        } else {
          number += title
          operateCount = 0
          if (number.first == "0" && number.count > 0) {
            number.removeFirst()
          }
          var numberArray = Array(number)
          if (numberArray.count > 3) {
            for i in 0..<numberArray.count - 2 {
              if (!numberArray[i].isNumber && numberArray[i + 1] == "0" && numberArray[i + 2].isNumber) {
                numberArray.remove(at: i + 1)
              }
            }
            number = String(numberArray)
          }
          
        }
        text.text = number
      }
    }
  }
  
  func calculate(expression: String) -> Int? {
    let expression = NSExpression(format: expression)
    if let result = expression.expressionValue(with: nil, context: nil) as? Int {
      return result
    } else {
      return nil
    }
  }
}


