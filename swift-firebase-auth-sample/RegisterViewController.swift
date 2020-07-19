import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
  var handle: Optional<AuthStateDidChangeListenerHandle> = nil
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

  let registerLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.text = "新規登録"
    return label
  }()

  let registerEmail: UITextField = {
    let textField = MyTextField()
    textField.placeholder = "メールアドレス"
    return textField
  }()

  let registerPassword: UITextField = {
    let textField = MyTextField()
    textField.placeholder = "パスワード"
    textField.isSecureTextEntry = true
    return textField
  }()

  let registerButton: UIButton = {
    let button = MyButton()
    button.setTitle("登録する", for: .normal)
    button.addTarget(self, action: #selector(doRegister), for: .touchUpInside)
    return button
  }()

  let toLoginButton: UIButton = {
    let button = MyButton(withBorder: false)
    button.setTitle("ログインはこちら", for: .normal)
    button.addTarget(self, action: #selector(toLogin), for: .touchUpInside)
    button.sizeToFit()
    button.widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
    return button
  }()

  @objc func doRegister() {
    let email = self.registerEmail.text ?? ""
    let password = self.registerPassword.text ?? ""
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      if let e = error {
        debugPrint(e)
      } else if let r: AuthDataResult = authResult {
        let user: User = r.user
        self.userDefaults.set(user.uid, forKey: "firebase_uid")
        globalFirebaseUser = user
      }
    }
  }

  @objc func toLogin() {
    let v = LoginViewController()
    self.navigationController?.present(v, animated: true)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    do {
      try self.signOutIfFirstBoot()
    } catch let signOutError as NSError {
      debugPrint("Error signing out: %@", signOutError)
    }
    self.view.backgroundColor = .white
    self.title = "登録"
    self.view.addSubview(self.serviceLabel)
    self.view.addSubview(self.registerLabel)
    self.view.addSubview(self.registerEmail)
    self.view.addSubview(self.registerPassword)
    self.view.addSubview(self.registerButton)
    self.view.addSubview(self.toLoginButton)

    self.layoutViews(topAnchor: self.view.safeAreaLayoutGuide.topAnchor)
  }

  func signOutIfFirstBoot() throws {
    if let user = Auth.auth().currentUser  {
      if let _ = self.userDefaults.string(forKey: "firebase_uid") {
        globalFirebaseUser = user
        self.state("ログイン済み")
      } else {
        try Auth.auth().signOut()
        self.state("UserDefaultsにはいないためアプリ削除後、FirebaseのKeyChainにUser情報が残っている状態")
      }
    } else {
      self.state("未ログイン")
    }
  }

  func layoutViews(topAnchor: NSLayoutYAxisAnchor) {
    self.serviceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
    self.serviceLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 24).isActive = true
    self.serviceLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -24).isActive = true

    self.registerLabel.topAnchor.constraint(equalTo: self.serviceLabel.bottomAnchor, constant: 24).isActive = true
    self.registerEmail.topAnchor.constraint(equalTo: self.registerLabel.bottomAnchor, constant: 16).isActive = true
    self.registerPassword.topAnchor.constraint(equalTo: self.registerEmail.bottomAnchor, constant: 16).isActive = true
    self.registerButton.topAnchor.constraint(equalTo: self.registerPassword.bottomAnchor, constant: 24).isActive = true

    self.registerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 24).isActive = true
    self.registerEmail.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16).isActive = true
    self.registerPassword.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16).isActive = true
    self.registerButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

    self.toLoginButton.topAnchor.constraint(equalTo: self.registerButton.bottomAnchor, constant: 36).isActive = true
    self.toLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
  }
}
