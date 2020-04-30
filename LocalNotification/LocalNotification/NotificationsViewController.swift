//
//  ViewController.swift
//  LocalNotification
//
//  Created by Tanya Burke on 2/20/20.
//  Copyright © 2020 Tanya Burke. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var notifications = [UNNotificationRequest](){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private let center = UNUserNotificationCenter.current()
    private let pendingNotification = PendingNotification()
    
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        checkForNotificationAuthorization()
        loadNotifications()
        configureRefreshControl()
        
        //setting this view controller as the UNNotificationcenterDelegate
        center.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController, let createVC = navController.viewControllers.first as? CreateNotificationViewController else {
            fatalError("could not downcast CreateNotificationViewConteoller")
        }
        
        createVC.delegate = self
    }
    
    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadNotifications), for: .valueChanged)
    }
    
  @objc  private func loadNotifications(){
        pendingNotification.getPendingNotifications { (requests) in
            self.notifications = requests
            
            //stop the refresh control from animating abd remove from UI
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func checkForNotificationAuthorization(){
        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized{
                print("app is authorized for notifications")
            } else{
                self.requestNotificationPermissions()
            }
        }
    }
    
    
    
    private func requestNotificationPermissions(){
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error{
                print("error requesting authorization: \(error)")
                return
            }
            if granted {
                print("acess granted")
            } else {
                print ("acess denied")
            }
        }
    }
    
    
    
}

extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
                return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath)
        let notification = notifications[indexPath.row]
        cell.textLabel?.text = notification.content.title
//        cell.imageView?.image = notification.content.
        cell.detailTextLabel?.text = notification.content.body
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //this listens for swipes
        if editingStyle == .delete{
            //we will delete the pending notification
            removeNotification(atIndexPath: indexPath)
        }
    }
    
    private func removeNotification(atIndexPath indexPath: IndexPath){
        //remove from U
        let notification = notifications[indexPath.row]
        center.removePendingNotificationRequests(withIdentifiers: [notification.identifier])
        
        //remove from array of notifications
        notifications.remove(at: indexPath.row)
        
        //remove from tableView
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension NotificationsViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(.alert)
    }
}

extension NotificationsViewController: CreateNotificationControllerDelegate {
    func didCreateNotification(_ createNotificationController: CreateNotificationViewController) {
        loadNotifications()
    }
    
    
}
