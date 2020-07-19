import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
  var handle: Optional<AuthStateDidChangeListenerHandle> = nil
  let userDefaults = UserDefaults.standard

  func state(_ s: String) {
    debugPrint(s)
    self.stateLabel.text = s
  }

  let stateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.lineBreakMode = .byCharWrapping
    label.numberOfLines = 0
    label.textColor = .black
    label.widthAnchor.constraint(equalToConstant: 300).isActive = true
    return label
  }()

  let firebaseUidLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    return label
  }()

  let registerLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.text = "新規登録"
    return label
  }()
  lazy var registerEmail: UITextField = {
    let textField = MyTextField()
    textField.placeholder = "メールアドレス"
    return textField
  }()

  lazy var registerPassword: UITextField = {
    let textField = MyTextField()
    textField.placeholder = "パスワード"
    textField.isSecureTextEntry = true
    return textField
  }()

  let registerButton: UIButton = {
    let button = UIButton()
    button.setTitle("新規登録", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(doRegister), for: .touchUpInside)
    return button
  }()

  let loginLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.text = "ログイン"
    return label
  }()

  let loginEmail: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.textColor = .black
    textField.placeholder = "Email"
    return textField
  }()

  let loginPassword: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.textColor = .black
    textField.placeholder = "Password"
    textField.isSecureTextEntry = true
    return textField
  }()

  let loginButton: UIButton = {
    let button = UIButton()
    button.setTitle("ログイン", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(doLogin), for: .touchUpInside)
    return button
  }()

  @objc func doRegister() {
    let email = self.registerEmail.text ?? ""
    let password = self.registerPassword.text ?? ""
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      if let r: AuthDataResult = authResult {
        let user: User = r.user
        self.userDefaults.set(user.uid, forKey: "firebase_uid")
        self.firebaseUidLabel.text = user.uid
      }
      if let e = error {
        print(e)
      }
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

  @objc func doLogin() {
    let email = self.loginEmail.text ?? ""
    let password = self.loginPassword.text ?? ""
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
      if let r: AuthDataResult = authResult {
        let user: User = r.user
        self.state("login success")
        self.userDefaults.set(user.uid, forKey: "firebase_uid")
        self.firebaseUidLabel.text = user.uid
      }
      if let e = error {
        print(e)
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.title = "登録"

    self.view.addSubview(self.stateLabel)
    self.view.addSubview(self.firebaseUidLabel)
    self.view.addSubview(self.registerLabel)
    self.view.addSubview(self.registerEmail)
    self.view.addSubview(self.registerPassword)
    self.view.addSubview(self.registerButton)
    self.view.addSubview(self.loginLabel)
    self.view.addSubview(self.loginEmail)
    self.view.addSubview(self.loginPassword)
    self.view.addSubview(self.loginButton)

    self.stateLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
    self.stateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16).isActive = true
    self.firebaseUidLabel.topAnchor.constraint(equalTo: self.stateLabel.bottomAnchor, constant: 8).isActive = true

    self.registerLabel.topAnchor.constraint(equalTo: self.firebaseUidLabel.bottomAnchor, constant: 24).isActive = true
    self.registerEmail.topAnchor.constraint(equalTo: self.registerLabel.bottomAnchor, constant: 16).isActive = true
    self.registerPassword.topAnchor.constraint(equalTo: self.registerEmail.bottomAnchor, constant: 16).isActive = true
    self.registerButton.topAnchor.constraint(equalTo: self.registerPassword.bottomAnchor, constant: 24).isActive = true

    self.registerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 24).isActive = true
    self.registerEmail.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16).isActive = true
    self.registerPassword.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16).isActive = true
    self.registerButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

    self.loginLabel.topAnchor.constraint(equalTo: self.registerButton.bottomAnchor, constant: 50).isActive = true
    self.loginEmail.topAnchor.constraint(equalTo: self.loginLabel.bottomAnchor, constant: 20).isActive = true
    self.loginPassword.topAnchor.constraint(equalTo: self.loginEmail.bottomAnchor, constant: 20).isActive = true
    self.loginButton.topAnchor.constraint(equalTo: self.loginPassword.bottomAnchor, constant: 20).isActive = true

    self.loginLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 22).isActive = true
    self.loginEmail.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 30).isActive = true
    self.loginPassword.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 30).isActive = true
    self.loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

    if let user = Auth.auth().currentUser  {
      debugPrint(user)
      if let uid = self.userDefaults.string(forKey: "firebase_uid") {
        self.state("already login.")
        self.firebaseUidLabel.text = uid
      } else {
        self.state("firebase auth is found, but user defaults not found")
        do {
          try Auth.auth().signOut()
        } catch let signOutError as NSError {
          debugPrint("Error signing out: %@", signOutError) 
        }
      }
    } else {
      self.state("not login.")
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
      print(auth)
      print(user as Any)
    }
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if let handle = self.handle {
      Auth.auth().removeStateDidChangeListener(handle)
    }
  }
}
