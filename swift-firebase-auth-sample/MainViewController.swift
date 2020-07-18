import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
  var handle: Optional<AuthStateDidChangeListenerHandle> = nil
  let registerLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.text = "新規登録"
    return label
  }()
  let registerEmail: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.textColor = .black
    textField.placeholder = "Email"
    return textField
  }()

  let registerPassword: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.textColor = .black
    textField.placeholder = "Password"
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
        UserDefaults.standard.set("firebase_uid", forKey: user.uid)
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
        UserDefaults.standard.set("firebase_uid", forKey: user.uid)
      }
      if let e = error {
        print(e)
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white

    self.view.addSubview(self.registerLabel)
    self.view.addSubview(self.registerEmail)
    self.view.addSubview(self.registerPassword)
    self.view.addSubview(self.registerButton)
    self.view.addSubview(self.loginLabel)
    self.view.addSubview(self.loginEmail)
    self.view.addSubview(self.loginPassword)
    self.view.addSubview(self.loginButton)

    self.registerLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
    self.registerEmail.topAnchor.constraint(equalTo: self.registerLabel.bottomAnchor, constant: 20).isActive = true
    self.registerPassword.topAnchor.constraint(equalTo: self.registerEmail.bottomAnchor, constant: 20).isActive = true
    self.registerButton.topAnchor.constraint(equalTo: self.registerPassword.bottomAnchor, constant: 20).isActive = true

    self.registerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 22).isActive = true
    self.registerEmail.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 30).isActive = true
    self.registerPassword.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 30).isActive = true
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
      if let uid = UserDefaults.standard.string(forKey: "firebase_uid") {
        debugPrint("already login. uid = \(uid)")
        debugPrint(user)
      } else {
        debugPrint("initialized")
        do {
          try Auth.auth().signOut()
        } catch let signOutError as NSError {
          debugPrint("Error signing out: %@", signOutError) 
        }
      }
    } else {
      debugPrint("not login")
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
