//
//  SceneDelegate.swift
//  TheBoyage
//
//  Created by Madeline on 4/10/24.
//

import Alamofire
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let session = Session(interceptor: NetworkInterceptor())

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        determineInitialViewController()
    }
    
    private func determineInitialViewController() {
        showLoadingScreen()
        if isUserLoggedIn() {
            validateToken { isValid in
                print("validate Token: \(isValid)")
                DispatchQueue.main.async {
                    self.setupTabBarController(isLoggedIn: isValid)
                }
            }
        } else {
            print("유저 디폴트에도 없음")
            DispatchQueue.main.async {
                self.setupTabBarController(isLoggedIn: false)
            }
        }
    }
    
    private func showLoadingScreen() {
        let loadingViewController = UIViewController()
        loadingViewController.view.backgroundColor = UIColor.systemBackground
        window?.rootViewController = loadingViewController
        window?.makeKeyAndVisible()
    }

    private func setupTabBarController(isLoggedIn: Bool) {
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .systemGray6
        tabBarController.tabBar.tintColor = .point
        tabBarController.tabBar.unselectedItemTintColor = .lightGray
        
        let vc1 = MainViewController()
        vc1.tabBarItem = UITabBarItem(title: "HOME", image: UIImage(systemName: "house"), tag: 0)
        
        let vc2 = AddContentViewController()
        vc2.tabBarItem = UITabBarItem(title: "POST", image: UIImage(systemName: "plus.app"), tag: 1)
        
        let vc3 = isLoggedIn ? MyPageViewController() : SignInViewController()
        vc3.tabBarItem = UITabBarItem(title: "MY PAGE", image: UIImage(systemName: "person.circle"), tag: 2)
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        tabBarController.viewControllers = [nav1, nav2, nav3]
        tabBarController.selectedIndex = isLoggedIn ? 0 : 2
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    private func validateToken(completion: @escaping (Bool) -> Void) {
        session.request(APIKey.baseURL.rawValue + "/v1/auth/refresh").validate()
            .response { response in
            switch response.result {
            case .success:
                // 토큰 유효성 검증 성공
                print("validateToken = success")
                completion(true)
            case .failure(let error):
                if let statusCode = response.response?.statusCode, statusCode == 418 || statusCode == 419 || statusCode == 403 {
                    print("validateToken = failure, \(statusCode)")
                    UserDefaults.standard.removeObject(forKey: "AccessToken")
                }
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

