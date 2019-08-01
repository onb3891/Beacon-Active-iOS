//
//  ViewController.swift
//  BeaconActive-Swift
//
//  Created by David Yang on 15/4/3.
//  Copyright (c) 2015年 Sensoro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var actionButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        image.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
        if SENLocationManager.sharedInstance.started == true{
            actionButton.setTitle("End Monitoring", for: .normal);
        }else{
            actionButton.setTitle("Start monitoring", for: .normal);
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        //UIApplication.sharedApplication().applicationIconBadgeNumber = 0;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func recevivedEvent(_ proximityRaw: Int, approximation: Double, rssi: Int ){
        actionButton.setTitle(("Proximity:\(proximityRaw) +/- \(approximation)m | RSSI:\(rssi)"), for: .normal)
    }
    
    //46D06053-9FAD-483B-B704-E576735CE1A3
    @IBAction func startMonitor(_ sender: Any) {
        if SENLocationManager.sharedInstance.started == false{
            actionButton.setTitle("End monitoring", for: .normal);
            SENLocationManager.sharedInstance.startMonitor(relaunch: false,updateCbk:recevivedEvent);
        }else{
            actionButton.setTitle("Start monitoring", for: .normal);
            SENLocationManager.sharedInstance.stopMonitor();
        }
    }
    @IBAction func saveToAlbum(sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(image.image!,
                                       self,#selector(image(image:didFinishSavingWithError:contextInfo:)),nil);
    }

    //
    @objc func image(image : UIImage, didFinishSavingWithError error : NSError!, contextInfo info: UnsafeRawPointer) {
        if error == nil {
            let alert = UIAlertView(title: "prompt", message: "Successfully saved", delegate: nil, cancelButtonTitle: "OK");
            alert.show();
        }else{
            let alert = UIAlertView(title: "prompt", message: "Save failed", delegate: nil, cancelButtonTitle: "OK");
            alert.show();
        }
    }
}

