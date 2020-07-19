import UIKit

class Util {
  static func window() -> UIWindow? {
    let window = UIApplication.shared.connectedScenes.filter({
      $0.activationState == .foregroundActive
    }).map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.filter({ $0.isKeyWindow })
            .first
    return window

  }

  static func replaceRootViewController(viewController: UIViewController) {
    if let window = Util.window() {
      if window.rootViewController?.presentedViewController != nil {
        window.rootViewController?.dismiss(animated: false) {
          window.rootViewController = viewController
        }
      } else {
        window.rootViewController = viewController
      }
    }
  }
}
