//
//  CreateNotificationViewController.swift
//  LocalNotification
//
//  Created by Tanya Burke on 2/20/20.
//  Copyright © 2020 Tanya Burke. All rights reserved.
//

import UIKit

protocol CreateNotificationControllerDelegate: AnyObject {
    
    func didCreateNotification(_ createNotificationController: CreateNotificationViewController)
}

class CreateNotificationViewController: UIViewController {

   
    @IBOutlet weak var titleTextFeild: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    weak var delegate: CreateNotificationControllerDelegate?
    
    private var timeInterval: TimeInterval = Date().timeIntervalSinceNow + 5 // current time plus 5 seconds
    
    //works with target action
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    private func createLocalNotification() {
        //step 1: create content
        //mutable- means changable
        //model
        let content = UNMutableNotificationContent()
        
        content.title = titleTextFeild.text ?? "No Title"
        content.body = "Local Notifications is awesome when used appropriately"
        content.subtitle = "Learning Local Notifications"
        content.sound = .default //only works in the background and the app is not on silent- please test on device
        //TODO: you can import your own souns file
        //content.sound = UNNotificationSound(named: UNNotificationSound(rawValue: "file.mp3"))
        
        //TODO: user dictionary info can hold additional data
       // content.userInfo = [:]
        
        
        //create identifier
        let identifier = UUID().uuidString
        
        
        //attachment
        if let imageURL = Bundle.main.url(forResource: "swift-logo", withExtension: "png"){
            do{
                      let attachment = try UNNotificationAttachment(identifier: identifier, url: imageURL, options: nil)
                content.attachments = [attachment]
            } catch {
               print("Error wit attachment\(error)")
            }
      
        } else{
            print("imageR esource can not be found")
        }
       //trigger can be of different types, location, calender etc
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        //add request to the unnnotificationcenter
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("error adding request \(error)")
            } else {
                print("request was succesfully handled")
            }
        }
        
    }
    
    
    
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
       //to avoid time being in the past
        guard sender.date > Date() else { return}
        
        //timeIntervalSinceNow
        timeInterval = sender.date.timeIntervalSinceNow
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.didCreateNotification(self)
        createLocalNotification()
        dismiss(animated: true)
    }
    
   
}
