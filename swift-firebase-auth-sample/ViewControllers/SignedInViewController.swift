import UIKit
import FirebaseAuth

class SignedInViewController: UIViewController {
  let userDefaults = UserDefaults.standard
  let user: User
  let serviceLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.text = "Firebase Login Sample Application"
    label.font = .italicSystemFont(ofSize: 24)
    return label
  }()

  lazy var firebaseUserLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.numberOfLines = 0
    label.text = "Email: \(self.user.email ?? "nil")\nEmailVerified: \(self.user.isEmailVerified)"
    return label
  }()

  let signOutButton: UIButton = {
    let button = MyButton()
    button.setTitle("ログアウト", for: .normal)
    button.addTarget(self, action: #selector(doSignOut), for: .touchUpInside)
    return button
  }()

  @objc func doSignOut() {
    self.userDefaults.removeObject(forKey: "firebase_uid")
    do {
      try Auth.auth().signOut()
    } catch let signOutError as NSError {
      debugPrint("Error signing out: %@", signOutError)
    }

    let c = RegisterViewController()
    Util.replaceRootViewController(viewController: UINavigationController(rootViewController: c))
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = .white
    self.view.addSubview(self.serviceLabel)
    self.view.addSubview(self.firebaseUserLabel)
    self.view.addSubview(self.signOutButton)

    self.serviceLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
    self.serviceLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 24).isActive = true
    self.serviceLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -24).isActive = true

    self.firebaseUserLabel.topAnchor.constraint(equalTo: self.serviceLabel.bottomAnchor, constant: 24).isActive = true
    self.firebaseUserLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 24).isActive = true

    self.signOutButton.topAnchor.constraint(equalTo: self.firebaseUserLabel.bottomAnchor, constant: 36).isActive = true
    self.signOutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
  }

  init(_ user: User) {
    self.user = user
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}
