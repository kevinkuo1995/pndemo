//
//  ViewController.swift
//  pndemo
//
//  Created by KUO Chin Wei on 2019/11/11.
//  Copyright © 2019 KUO Chin Wei. All rights reserved.
//

import UIKit
import Firebase
import LBTATools

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = .systemGray
        view.addSubview(myView)
        myView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        myView.stack(UIView(),
                     myTitleLabel.withSize(.init(width: 100, height: 60)) ,
                     myTitle.withSize(.init(width: view.bounds.width - 100, height: 100)),
                     myBodyLabel.withSize(.init(width: 100, height: 60)),
                     myBody.withSize(.init(width: view.bounds.width - 100, height: 100)),
                     myButton.withSize(.init(width: 100, height: 60)),
                     UIView(),
                     alignment:  .center)
    }


    let myView: UIView = {
        let mv = UIView()
        mv.backgroundColor = .systemGray
        return mv
    }()
    
    let myTitleLabel: UILabel = {
       let ml = UILabel()
        ml.textAlignment = .center
        ml.text = "Enter Title"
        return ml
    }()
    
    let myBodyLabel: UILabel = {
       let ml = UILabel()
        ml.textAlignment = .center
        ml.text = "Enter Body"
        return ml
    }()
    
    let myButton: UIButton = {
       let mb = UIButton()
        mb.setTitle("PUSH", for: .normal)
        mb.addTarget(self, action: #selector(send), for: .touchUpInside)
        return mb
    }()
    
    let myTitle: UITextView = {
       let mt = UITextView()
        mt.isScrollEnabled = false
        mt.backgroundColor = .white
        mt.font = .systemFont(ofSize: 24)
        return mt
    }()
    
    let myBody: UITextView = {
       let mt = UITextView()
        mt.isScrollEnabled = false
        mt.backgroundColor = .white
        mt.font = .systemFont(ofSize: 20)
        return mt
    }()
    
    @objc fileprivate func send() {
        sendPushNotification(to: (UIApplication.shared.delegate as! AppDelegate).fcmToken, title: myTitle.text ?? "Title", body: myBody.text ?? "Body", uid: "uid")
    }
    
    func  sendPushNotification(to token: String, title: String, body: String, uid: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : uid]
        ]

        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=Firebase 伺服器金鑰", forHTTPHeaderField: "Authorization")

        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        myBody.resignFirstResponder()
        myTitle.resignFirstResponder()
    }
}

