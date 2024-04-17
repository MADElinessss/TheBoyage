//
//  SceneDelegate.swift
//  TheBoyage
//
//  Created by Madeline on 4/10/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .systemGray6
        tabBarController.tabBar.tintColor = .point
        tabBarController.tabBar.unselectedItemTintColor = .lightGray
        
        let vc1 = MainViewController()
        let vc2 = AddContentViewController()
        let vc3 = determineInitialViewController()
    
        vc1.tabBarItem = UITabBarItem(title: "HOME", image: UIImage(systemName: "doc.text.image"), selectedImage: UIImage(named: "doc.text.image.fill"))
        vc1.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        vc1.tabBarItem.tag = 0
        
        vc2.tabBarItem = UITabBarItem(title: "POST", image: UIImage(systemName: "plus.circle.fill"), selectedImage: UIImage(systemName: "plus.circle.fill"))
        vc2.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        vc2.tabBarItem.tag = 1
        
        vc3.tabBarItem = UITabBarItem(title: "MY PAGE", image: UIImage(systemName: "person.fill"), selectedImage: UIImage(systemName: "person.fill"))
        vc3.tabBarItem.tag = 2

        
        tabBarController.viewControllers = [vc1, vc2, vc3].map { UINavigationController(rootViewController: $0) }
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    private func determineInitialViewController() -> UIViewController {
        if isUserLoggedIn() {
            validateToken { isValid in
                DispatchQueue.main.async { // 비동기 처리에서 UI 업데이트를 위해 메인 스레드 사용
                    if let tabBarController = self.window?.rootViewController as? UITabBarController,
                       let viewControllers = tabBarController.viewControllers,
                       viewControllers.count > 2 {
                        let vc3 = isValid ? MyPageViewController() : SignInViewController()
                        let navController = UINavigationController(rootViewController: vc3)
                        tabBarController.viewControllers?[2] = navController
                    }
                }
            }
            return SignInViewController()
        } else {
            return SignInViewController()
        }
    }
    
    private func validateToken(completion: @escaping (Bool) -> Void) {
        LoginNetworkManager.refreshToken().subscribe { event in
            switch event {
            case .success(let refreshToken):
                UserDefaults.standard.set(refreshToken.accessToken, forKey: "AccessToken")
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    private func isUserLoggedIn() -> Bool {
        if let accessToken = UserDefaults.standard.string(forKey: "AccessToken"), !accessToken.isEmpty {
            return true
        }
        return false
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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

