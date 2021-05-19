//
//  Scene.swift
//  SredaTest
//
//  Created by Dmitry Muravev on 17.05.2021.
//

import UIKit

protocol TargetScene {
    var transition: SceneTransitionType { get }
}

enum Scene {
    case mainTab
    //case details(PhotoDetailsViewModel)
}

extension Scene: TargetScene {
    var transition: SceneTransitionType {
        switch self {
        case .mainTab:
            let mainTabBarController = MainTabBarController()

            var inputVC = InputScreenViewController.initFromNib()
            let inputViewModel = InputScreenViewModel()
            inputVC.bind(to: inputViewModel)

            var showVC = ShowScreenViewController.initFromNib()
            let showViewModel = ShowScreenViewModel()
            showVC.bind(to: showViewModel)

            let inputTabBarItem = UITabBarItem(
                title: "InputTab",
                image: UIImage(named: "icon_input"),
                tag: 0
            )
            let showTabBarItem = UITabBarItem(
                title: "ShowTab",
                image: UIImage(named: "icon_show"),
                tag: 1
            )

            inputVC.tabBarItem = inputTabBarItem
            showVC.tabBarItem = showTabBarItem
            
            mainTabBarController.viewControllers = [
                inputVC,
                showVC
            ]

            return .tabBar(mainTabBarController)
        //case let .photoDetails(viewModel):
        //    var vc = PhotoDetailsViewController.initFromNib()
        //    vc.bind(to: viewModel)
        //    return .present(vc)
        }
    }
}


