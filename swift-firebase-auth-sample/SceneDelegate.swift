import UIKit
import SwiftUI
import FirebaseAuth

var globalFirebaseUser: User? = nil

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let userDefaults = UserDefaults.standard

    var window: UIWindow?

    func signOutIfFirstBoot() throws -> User?  {
        if let user = Auth.auth().currentUser  {
            if let _ = self.userDefaults.string(forKey: "firebase_uid") {
              return user
            } else {
                try Auth.auth().signOut()
            }
        }
      return  nil
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        do {
            globalFirebaseUser = try self.signOutIfFirstBoot()
        } catch let signOutError as NSError {
            debugPrint("Error signing out: %@", signOutError)
        }
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            if let user = globalFirebaseUser {
                window.rootViewController = UINavigationController(rootViewController: SignedInViewController(user))
            } else {
                window.rootViewController = UINavigationController(rootViewController: RegisterViewController())
            }
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

