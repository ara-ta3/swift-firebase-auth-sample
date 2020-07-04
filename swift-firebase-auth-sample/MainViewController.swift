import UIKit
import FirebaseAuth


class MainViewController: UIViewController {
  var handle: Optional<AuthStateDidChangeListenerHandle> = nil
  override func viewDidLoad() {
    super.viewDidLoad()
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
