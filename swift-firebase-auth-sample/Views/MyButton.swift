import UIKit

class MyButton: UIButton {

  init(withBorder: Bool = true) {
    super.init(frame: .zero)
    self.setTitleColor(.black, for: .normal)
    self.translatesAutoresizingMaskIntoConstraints = false
    if (withBorder) {
      self.layer.borderColor = UIColor.gray.cgColor
      self.layer.borderWidth = 1
      self.layer.cornerRadius = 8
    }
    self.clipsToBounds = true
    self.titleEdgeInsets = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
    self.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
    self.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  /**
   * @see https://qiita.com/hiroism/items/e0659d547e664d6c5daf
   */
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    drawRipple(touch: touches.first!)
  }
  private func drawRipple(touch: UITouch) {
    let rippleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    rippleView.layer.cornerRadius = 100
    rippleView.center = touch.location(in: self)
    rippleView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    rippleView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
    addSubview(rippleView)
    UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: UIView.AnimationOptions.curveEaseIn,
            animations: {
              rippleView.transform = CGAffineTransform(scaleX: 1, y: 1)
              rippleView.backgroundColor = .clear
            },
            completion: { (finished: Bool) in
              rippleView.removeFromSuperview()
            }
    )
  }
}
