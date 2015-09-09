//
//  ViewController.swift
//  bassolEventik4
//
//  Created by charlie on 8/10/15.
//  Copyright (c) 2015 charlie. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager:CLLocationManager = CLLocationManager()
    var locCoords : CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationController?.navigationBarHidden = true
        //let gps = MyGPSGetter() not working... dunno why!!!!!!!!!!!
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 50
        self.locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("entra a locationmanager...")
        
        let location = locations.last as! CLLocation
        
        println("didUpdateLocations:  \(location.coordinate.latitude), \(location.coordinate.longitude)")
        self.locCoords = location
        let lat = "\(location.coordinate.latitude)"
        let lonj = "\(location.coordinate.longitude)"
        Auxiliar.sigletonHelper.setLat(lat)
        Auxiliar.sigletonHelper.setLonj(lonj)
        
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined:
            println("not determined")
            locationManager.requestAlwaysAuthorization()
            break
        case .AuthorizedWhenInUse:
            println("autorizado en uso ")
            locationManager.startUpdatingLocation()
            break
        case .AuthorizedAlways:
            locationManager.startUpdatingLocation()
            println("siempre autorizado")
            break
        case .Restricted:
            println("restringido")
            break
        case .Denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            println("denegado ")
            break
        default:
            println("denegado por k entro a default... case: \(status) ")
            break
        }
    }

    @IBAction func facebookClicked(sender: AnyObject) {
        println("facebook clicked..");
    }
}

