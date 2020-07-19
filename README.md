swift-firebase-auth-sample
---

# SceneDelegate

- ログイン済みならSignedInViewControllerを表示
  - アプリ削除等でUserDefaultsにデータがない場合はログアウトさせる
    - FirebaseのデータはKeyChainに残っているため、削除した後もログインができてしまう
    - そのためUserDefaultsにFirebaseUIDを保存させて、存在していない場合は強制的にログアウトさせてFirebaseのデータを消すようにしている
- 未ログインならRegisterViewControllerを表示
  - ログインはこちらからLoginViewControllerを表示させる

# SignedInVSignedInViewController

FirebaseUser情報を表示させ、ログアウトボタンを押した際にRegisterViewControllerへと移動させる  

<img src="https://user-images.githubusercontent.com/2089153/87870223-df093000-c9e0-11ea-875b-e8c704304905.png" width="320" />

# RegisterViewController

<img src="https://user-images.githubusercontent.com/2089153/87870273-36a79b80-c9e1-11ea-8ac3-af9cba8946ae.png" width="320" />

# LoginViewController

<img src="https://user-images.githubusercontent.com/2089153/87870275-37d8c880-c9e1-11ea-88d4-aa428aa5de7d.png" width="320" />





