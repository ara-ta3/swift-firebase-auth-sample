import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
  let userDefaults = UserDefaults.standard

  func state(_ s: String) {
    debugPrint(s)
  }

  let serviceLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.text = "Firebase Login Sample Application"
    label.font = .italicSystemFont(ofSize: 24)
    return label
  }()

  let loginLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.text = "ログイン"
    return label
  }()

  let loginEmail: UITextField = {
    let textField = MyTextField()
    textField.placeholder = "メールアドレス"
    return textField
  }()

  let loginPassword: UITextField = {
    let textField = MyTextField()
    textField.placeholder = "パスワード"
    textField.isSecureTextEntry = true
    return textField
  }()

  let loginButton: UIButton = {
    let button = MyButton()
    button.setTitle("ログイン", for: .normal)
    button.addTarget(self, action: #selector(doLogin), for: .touchUpInside)
    return button
  }()

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

  @objc func doLogin() {
    let email = self.loginEmail.text ?? ""
    let password = self.loginPassword.text ?? ""
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
      if let e = error {
        debugPrint(e)
      } else if let r: AuthDataResult = authResult {
        let user: User = r.user
        self.state("ログイン成功")
        self.userDefaults.set(user.uid, forKey: "firebase_uid")
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.title = "ログイン"

    self.view.addSubview(self.serviceLabel)
    self.view.addSubview(self.loginLabel)
    self.view.addSubview(self.loginEmail)
    self.view.addSubview(self.loginPassword)
    self.view.addSubview(self.loginButton)


    self.layoutViews(topAnchor: self.view.safeAreaLayoutGuide.topAnchor)
  }

  func layoutViews(topAnchor: NSLayoutYAxisAnchor) {
    self.serviceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
    self.serviceLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 24).isActive = true
    self.serviceLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -24).isActive = true
    self.loginLabel.topAnchor.constraint(equalTo: self.serviceLabel.bottomAnchor, constant: 48).isActive = true
    self.loginEmail.topAnchor.constraint(equalTo: self.loginLabel.bottomAnchor, constant: 16).isActive = true
    self.loginPassword.topAnchor.constraint(equalTo: self.loginEmail.bottomAnchor, constant: 16).isActive = true
    self.loginButton.topAnchor.constraint(equalTo: self.loginPassword.bottomAnchor, constant: 24).isActive = true

    self.loginLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 24).isActive = true
    self.loginEmail.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16).isActive = true
    self.loginPassword.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16).isActive = true
    self.loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
  }
}
