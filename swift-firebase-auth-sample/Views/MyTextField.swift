import UIKit

class MyTextField: UITextField {
  @IBInspectable var padding: CGPoint = CGPoint(x: 8.0, y: 16.0)
  let screenSize = UIScreen.main.bounds.size

  override func textRect(forBounds bounds: CGRect) -> CGRect {
    bounds.insetBy(dx: self.padding.x, dy: self.padding.y)
  }

  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    bounds.insetBy(dx: self.padding.x, dy: self.padding.y)
  }

  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    bounds.insetBy(dx: self.padding.x, dy: self.padding.y)
  }

  init() {
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.textColor = .black
    self.layer.borderColor = UIColor.gray.cgColor
    self.layer.borderWidth = 1
    self.layer.cornerRadius = 8
    self.autocorrectionType = .no
    self.autocapitalizationType = .none
    self.widthAnchor.constraint(equalToConstant: self.screenSize.width - 32).isActive = true
    self.heightAnchor.constraint(equalToConstant: 48).isActive = true
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
