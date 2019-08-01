//
//  SENLocationManager.swift
//  BeaconActive-Swift
//
//  Created by David Yang on 15/4/3.
//  Copyright (c) 2015年 Sensoro. All rights reserved.
//

import UIKit
import CoreLocation

class SENLocationManager: NSObject, CLLocationManagerDelegate {

    static let sharedInstance = SENLocationManager();

    var updateCbk : ((Int, Double, Int) -> Void)?
    let locationManager = CLLocationManager();
    var started = false;
    var monitorRegion : CLBeaconRegion!;

    fileprivate override init(){
        
        super.init();
        if UIDevice.current.systemVersion.compare("8.0", options: .numeric, range: nil, locale: nil) != .orderedAscending {
            locationManager.requestAlwaysAuthorization();
        }
        locationManager.delegate = self;
        
        monitorRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "23A01AF0-232A-4518-9C0E-323FB773F5EF")!,
            identifier: "SensoroBeaconActiveTest");
        
//        monitorRegion.notifyOnEntry = true;
//        monitorRegion.notifyOnExit = true;
    }
    
    func startMonitor( relaunch : Bool,  updateCbk: ((Int, Double, Int) -> Void)?){
        self.updateCbk = updateCbk
        if relaunch == false {
            locationManager.startMonitoring(for: monitorRegion);
            locationManager.startRangingBeacons(in: monitorRegion);
            NSLog("Start monitor region!");
        }else{
            locationManager.startRangingBeacons(in: monitorRegion);
            NSLog("During the relauch app, don't restart monitor region!");
        }
        started = true;
    }
    
    func stopMonitor(){
        locationManager.stopMonitoring(for: monitorRegion);
        started = false;
        NSLog("Stop monitor region!");
    }
    
    func sendNotification(notify : String){
        let notification = UILocalNotification()
        notification.alertBody = notify
        
//        notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        switch state {
        case .inside:
            let now = Date();
            let formatter = DateFormatter();
            formatter.dateFormat = "YYYY/MM/dd HH:mm:ss";
            sendNotification(notify: "Enter region at \(formatter.string(from: now))");
            NSLog("Enter region at \(formatter.string(from: now))");
        case .outside:
            let now = Date();
            let formatter = DateFormatter();
            formatter.dateFormat = "YYYY/MM/dd HH:mm:ss";
            sendNotification(notify: "Exit  region at \(formatter.string(from: now))");
            NSLog("Exit  region at \(formatter.string(from: now))");
        case .unknown:
            NSLog("This region state was unknown!");
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        NSLog("Found beacons : %@", beacons);
        for beacon in beacons{
            print("beacon: \(beacon.description)")
            if let cbk = self.updateCbk {
                if beacons.count > 1 {
                    cbk(-100,-100,-100)
                } else {
                    
                    cbk(beacon.proximity.rawValue,(100 * beacon.accuracy).rounded()/100, beacon.rssi)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("did Fail With Error : %@", error as NSError);
    }
    
//    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
//        NSLog("Found beacons : %@", beacons);
//    }
}
