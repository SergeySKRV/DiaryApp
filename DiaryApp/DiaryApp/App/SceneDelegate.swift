//
//  SceneDelegate.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 06.05.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)

        let repository = CoreDataDiaryRepository()

        let listNavigationController = UINavigationController()
        let listRouter = DiaryRouter(navigationController: listNavigationController, repository: repository)
        let listViewModel = DiaryListViewModel(repository: repository)
        let listViewController = DiaryListViewController(viewModel: listViewModel, router: listRouter)
        listNavigationController.setViewControllers([listViewController], animated: false)
        
        listNavigationController.tabBarItem = UITabBarItem(title: L10n.tabList, image: UIImage(systemName: "list.bullet"), selectedImage: UIImage(systemName: "list.bullet.rectangle"))
        
        let calendarNavigationController = UINavigationController()
        let calendarRouter = DiaryRouter(navigationController: calendarNavigationController, repository: repository)
        let calendarViewModel = CalendarViewModel(repository: repository)
        let calendarViewController = CalendarViewController(viewModel: calendarViewModel, router: calendarRouter)
        calendarNavigationController.setViewControllers([calendarViewController], animated: false)
        
        calendarNavigationController.tabBarItem = UITabBarItem(title: L10n.tabCalendar, image: UIImage(systemName: "calendar"), selectedImage: UIImage(systemName: "calendar.circle.fill"))
        
        let settingsNavigationController = UINavigationController()
        let settingsViewModel = SettingsViewModel()
        let settingsViewController = SettingsViewController(viewModel: settingsViewModel)
        settingsNavigationController.setViewControllers([settingsViewController], animated: false)
        
        settingsNavigationController.tabBarItem = UITabBarItem(title: L10n.tabSettings, image: UIImage(systemName: "gear"), selectedImage: UIImage(systemName: "gear.circle.fill"))
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([listNavigationController, calendarNavigationController, settingsNavigationController], animated: false)
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        self.window = window
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

