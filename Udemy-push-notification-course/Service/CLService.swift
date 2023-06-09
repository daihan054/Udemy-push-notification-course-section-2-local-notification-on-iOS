//
//  CLService.swift
//  Udemy-push-notification-course
//
//  Created by REVE Systems on 11/5/23.
//

import Foundation
import CoreLocation

class CLService: NSObject {
    
    private override init() { }
    static let shared = CLService()
    let locationManager = CLLocationManager()
    var shouldSetRegion = true
    
    func authorize() {
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func updateLocation() {
        shouldSetRegion = true
        locationManager.startUpdatingLocation()
    }
}

extension CLService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("got location 1")
        
        guard let currentLocation = locations.first, shouldSetRegion else {
            return
        }
        
        shouldSetRegion = false
        print("got location 2")
        let region = CLCircularRegion(center: currentLocation.coordinate, radius: 20, identifier: "startPosition")
        manager.startMonitoring(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Did enter region via CL")
        NotificationCenter.default.post(name: NSNotification.Name("internalNotification.enteredRegion"), object: nil)
    }
}
