//
//  MeetingTabBarController.swift
//  AppTest
//
//  Created by Сергей Аршинов on 30.05.2023.
//

import UIKit

class MeetingTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        createTabs()
    }
    
    private func setup() {
        let gesture = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        gesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gesture)
    }
    
    private func createTabs() {
        let meetingEditingViewController = MeetingEditingViewController()
        meetingEditingViewController.tabBarItem = UITabBarItem(title: "Edit", image: UIImage(systemName: "pencil"), tag: 0)
        
        let meetingViewingViewController = MeetingViewingViewController()
        meetingViewingViewController.tabBarItem = UITabBarItem(title: "View", image: UIImage(systemName: "list.bullet.rectangle"), tag: 1)
        
        viewControllers = [meetingEditingViewController, meetingViewingViewController]
    }
}
