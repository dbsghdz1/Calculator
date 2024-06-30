//
//  ViewController.swift
//  CalculatorClone
//
//  Created by 김윤홍 on 6/26/24.
//

import UIKit

import SnapKit

class ProtraitMode: UIViewController {
  
  let text = UILabel()
  let verticalStackView = UIStackView()
  let baselineStackView = UIStackView()
  
  private let stackViewHorizons: [UIStackView] = {
    let horizontalStackViews = (0..<5).map { _ -> UIStackView in
      let stackView = UIStackView()
      stackView.axis = .horizontal
      stackView.backgroundColor = .black
      stackView.distribution = .fillEqually
      stackView.spacing = 10
      return stackView
    }
    return horizontalStackViews
  }()
  
  private lazy var buttons: [UIButton] = {
    let titles = ["AC", "+/-", "%", "÷", "7", "8", "9", "×", "4", "5", "6", "-", "1", "2", "3", "+", "     0", ".", "="]
    return titles.map { title in
      let button = UIButton(type: .system)
      button.setTitle(title, for: .normal)
      button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
      button.setTitleColor(.white, for: .normal)
      if "÷×-+=".contains(title) {
        button.backgroundColor = UIColor(red: 201/255, green: 52/255, blue: 0/255, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 50)
      } else if "AC+/-%".contains(title) {
        button.backgroundColor = .gray
      } else {
        button.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1.0)
      }
      if title == "     0" {
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
      }
      return button
    }
  }()
  
  override func viewDidLoad() {
    view.backgroundColor = .black
    addView()
    setUpText()
    setUpVerticalStackView()
    setUpStackView()
    setUpConstraints()
  }
  
  override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransition(to: newCollection, with: coordinator)
    
    coordinator.animate(alongsideTransition: { (context) in
      guard let windowInterfaceOrientation = self.windowInterfaceOrientation else { return }
      
      if windowInterfaceOrientation.isLandscape {
        print("landscape")
      } else {
        print("portrait")
      }
    })
  }
  
  private var windowInterfaceOrientation: UIInterfaceOrientation? {
    return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
  }
  
  //layout이 모두 다 잡히면 호출되는 메서드.
  override func viewDidLayoutSubviews() {
    let oneLineWidth = CGFloat(verticalStackView.frame.size.width)
    let viewsCount = CGFloat(stackViewHorizons[0].arrangedSubviews.count)
    let hStackSpacing = stackViewHorizons[0].spacing
    let width: CGFloat = (oneLineWidth / viewsCount) - hStackSpacing
    
    for button in buttons {
      button.layer.cornerRadius = width / 2
    }
  }
  
  func setUpText() {
    text.text = "0"
    text.backgroundColor = .black
    text.font = UIFont.boldSystemFont(ofSize: 90)
    text.textColor = .white
    text.textAlignment = .right
    text.adjustsFontSizeToFitWidth = true
    text.numberOfLines = 1
    text.minimumScaleFactor = 0.5
  }
  
  func setUpVerticalStackView() {
    verticalStackView.backgroundColor = .black
    verticalStackView.axis = .vertical
    verticalStackView.spacing = 10
    verticalStackView.distribution = .fillEqually
  }
  
  func setUpConstraints() {
    text.snp.makeConstraints { make in
      make.bottom.equalTo(verticalStackView.snp.top).offset(-30)
      make.leading.trailing.equalToSuperview().inset(10)
      make.height.equalTo(100)
    }
    
    verticalStackView.snp.makeConstraints { make in
      make.bottom.equalTo(view.snp.bottom).inset(10)
      make.leading.trailing.equalToSuperview().inset(10)
    }
    
    for index in 0..<16 {
      buttons[index].snp.makeConstraints { make in
        make.height.equalTo(buttons[index].snp.width)
      }
    }
  }
  
  func setUpStackView() {
    baselineStackView.spacing = 10
    baselineStackView.axis = .horizontal
    baselineStackView.distribution = .fillEqually
  }
  
  func addView() {
    view.addSubview(text)
    view.addSubview(verticalStackView)
    for stackViewHorizon in stackViewHorizons {
      verticalStackView.addArrangedSubview(stackViewHorizon)
    }
    
    for i in 0..<17 {
      stackViewHorizons[i / 4].addArrangedSubview(buttons[i])
    }
    stackViewHorizons[4].addArrangedSubview(baselineStackView)
    baselineStackView.addArrangedSubview(buttons[17])
    baselineStackView.addArrangedSubview(buttons[18])
  }
}

#Preview {
  let vc = Message()
  return vc
}
