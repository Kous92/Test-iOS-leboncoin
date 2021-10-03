//
//  AppDelegate.swift
//  TestLeboncoiniOS
//
//  Created by Koussaïla Ben Mamar on 02/10/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /* Les Storyboards et XIB sont interdits dans ce test. De plus la compatibilité avec iOS 12 est nécessaire.
     SceneDelegate.swift (iOS 13 requis) et Main.storyboard sont donc supprimés.
     J'ai suivi ce tuto ici pour configurer le projet: https://youtube.com/watch?v=jpe-rrBHRSU
    */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = MainViewController() // La vue de départ, lorsqu'on lance l'application.
        
        return true
    }
}

