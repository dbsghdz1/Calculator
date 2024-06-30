//
//  CalculatorView.swift
//  Practice3
/*  view 생성시 고려?
 사용자에게 보여줘야하는 화면이 변경되면..? -> 변경을 해달라는 호출만 하고 진짜 변경은 다른곳에서
 뷰는 바보다 .. 그냥 멍청한 기능만 구현, 데이터 받으면 화면에만 표시 하기
 모델이 가지고 있는 정보 따로 저장하지말자!
 
 */
//
//  Created by 김윤홍 on 6/21/24.
//

import UIKit

import SnapKit

class CalculatorView: UIViewController {
  
  private var inputData: Data = Data()
  private let calculator = Calculator()
  
  //  horizontalStackView 배열
  private lazy var horizontalStackViews: [UIStackView] = {
    let stackViews = (0..<4).map { _ -> UIStackView in
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
    return stackViews
  }()
  
  // 계산기 버튼생성하기
  private lazy var calculatorButtons: [UIButton] = {
    let titles = ["7", "8", "9", "+", "4", "5", "6", "-", "1", "2", "3", "*", "AC", "0", "=", "/"]
    return titles.map { title in
      let button = UIButton(type: .system)
      button.setTitle(title, for: .normal)
      if let _ = Int(title) {
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
  
  // 계산결과를 나타내는 UILabel
  private lazy var resultLabel: UILabel = {
    let label = UILabel()
    label.text = "0"
    label.textColor = .white
    label.backgroundColor = .black
    label.font = UIFont.boldSystemFont(ofSize: 60)
    label.textAlignment = .right
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    label.numberOfLines = 1
    return label
  }()
  
  // verticalStackView
  private lazy var verticalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.backgroundColor = .black
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    return stackView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    view.addSubview(resultLabel)
    view.addSubview(verticalStackView)
    
    setupHorizontalStackViews()
    setupConstraints()
    setupButtons()
  }
  
  //  verticalStackView 에 horizontalStackView 설정
  private func setupHorizontalStackViews() {
    horizontalStackViews.forEach {
      verticalStackView.addArrangedSubview($0)
    }
  }
  
  // 제약 조건 설정
  private func setupConstraints() {
    verticalStackView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(resultLabel.snp.bottom).offset(60)
      $0.width.equalTo(350)
    }
    
    resultLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(30)
      $0.top.equalToSuperview().offset(200)
      $0.height.equalTo(100)
    }
  }
  
  // 버튼 추가
  private func setupButtons() {
    for (index, button) in calculatorButtons.enumerated() {
      let stackIndex = index / 4
      horizontalStackViews[stackIndex].addArrangedSubview(button)
      button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
  }
  
  // 버튼 클릭 이벤트 처리
  @objc private func buttonClicked(_ sender: UIButton) {
    guard let buttonText = sender.currentTitle else { return }
    
    switch buttonText {
    case "AC":
      inputData.text = "0"
      
    case "=":
      if let intValue = calculator.calculate(inputData.text) {
        inputData.text = String(intValue)
      } else {
        inputData.text = "ERROR PRESS AC"
      }
      
    default:
      inputData.text += buttonText
    }
    resultLabel.text = calculator.isValidExpression(inputData.text)
    inputData.text = calculator.isValidExpression(inputData.text)
  }
}
