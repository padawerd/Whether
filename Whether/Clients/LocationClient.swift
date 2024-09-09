//
//  LocationClient.swift
//  Whether
//
//  Created by David Padawer on 9/7/24.
//

import CoreLocation

class LocationClient: NSObject {
    
    static let shared = LocationClient()
    
    var callback: ((String?) -> Void)?
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()

    private override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.distanceFilter = 10
    }
    
    func getCurrentLocation(callback: @escaping (String?) -> Void) {
        self.callback = callback
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.stopUpdatingLocation()
        self.locationManager.requestLocation()
    }
}

extension LocationClient: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, 
                         didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if (error == nil) {
                    if let placemark = placemarks?.first {
                        if let locality = placemark.locality, let administrativeArea = placemark.administrativeArea {
                            self.callback?("\(locality), \(administrativeArea)")
                            return
                        }
                    }
                }
                // fall back to lat/long in text box
                self.callback?("\(location.coordinate.latitude), \(location.coordinate.longitude)")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Swift.Error) {
        self.callback?(nil)
    }
}
