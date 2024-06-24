//
//  ViewController.swift
//  Practice3
//
//  Created by 김윤홍 on 6/21/24.
//
//
import UIKit

import SnapKit

class View: UIViewController {
  private let label = UILabel()
  private let stackViewVertical = UIStackView()
  private var calculatorLabel: Data = Data()
  private let calculator = Calculator()
  
  private let stackViewHorizons: [UIStackView] = {
    let horizontalStackViews = (0..<4).map { _ -> UIStackView in
      let stackView = UIStackView()
      stackView.axis = .horizontal
      stackView.backgroundColor = .black
      stackView.distribution = .fillEqually
      stackView.spacing = 10
      stackView.snp.makeConstraints { make in
        make.height.equalTo(80)
      }
      return stackView
    }
    return horizontalStackViews
  }()
  
  private let buttons: [UIButton] = {
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
    view.addSubview(label)
    view.addSubview(stackViewVertical)
    
    makeLabel()
    makeVerticalStackView()
    setupHorizontalStackView()
    setupConstraints()
    addButton()
  }

  private func makeLabel() {
    label.text = "0"
    label.textColor  = .white
    label.backgroundColor = .black
    label.font = UIFont.boldSystemFont(ofSize: 60)
    label.textAlignment = .right
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    label.numberOfLines = 1
  }

  private func makeVerticalStackView() {
    stackViewVertical.axis = .vertical
    stackViewVertical.backgroundColor = .black
    stackViewVertical.distribution = .fillEqually
    stackViewVertical.spacing = 10
  }

  private func setupHorizontalStackView() {
    for i in stackViewHorizons {
      stackViewVertical.addArrangedSubview(i)
    }
  }
  
  private func setupConstraints() {
    stackViewVertical.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(label.snp.bottom).offset(60)
      $0.width.equalTo(350)
    }

    label.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(30)
      $0.top.equalToSuperview().offset(200)
      $0.height.equalTo(100)
    }
  }

  private func addButton() {
    for (index, button) in buttons.enumerated() {
      let stackIndex = index / 4
      stackViewHorizons[stackIndex].addArrangedSubview(button)
      button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
  }
  
  @objc private func buttonClicked(_ sender: UIButton) {
    guard let buttonText = sender.currentTitle else { return }

    switch buttonText {
    case "AC":
      calculatorLabel.text = ""
      label.text = "0"
    case "=":
      do {
        let result = try calculator.isValidExpression(calculatorLabel.text)
      } catch Calculator.CaluculateError.multipleOperatorsError {
        label.text = "ERROR PRESS AC!"
      } catch Calculator.CaluculateError.startingZeroError {
        label.text = "ERROR PRESS AC!"
      } catch {
        label.text = "UNKNOWN ERROR"
      }
    default:
      if "+-/*".contains(buttonText) {
        calculatorLabel.text += buttonText
      } else {
        calculatorLabel.text += buttonText
      }
      label.text = calculatorLabel.text
    }
  }
}


