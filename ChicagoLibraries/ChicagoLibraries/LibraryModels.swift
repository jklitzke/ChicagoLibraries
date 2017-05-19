//
//  Libraries.swift
//  ChicagoLibraries
//
//  Created by James Klitzke on 1/10/17.
//  Copyright © 2017 James Klitzke. All rights reserved.
//

import Foundation
import MapKit

class JSONModel : NSObject {
    
    init(data: Any?) {
        super.init()
        if let jsonDictionary = data as? [String : Any] {
            setValuesForKeys(jsonDictionary)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("WARNING: Tried to set value for undfined key =\(key)")
    }
}

class Library : JSONModel, MKAnnotation {
    var teacher_in_the_library : String?
    var zip : String?
    var hours_of_operation : String?
    var website : Website?
    var address : String?
    var city : String?
    var phone : String?
    var location : Location?
    var state : String?
    var cybernavigator : String?
    var name_ : String?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "website" {
            website = Website(data: value)
        }
        else if key == "location" {
            location = Location(data: value)
            
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
    
    // MARK: - MKAnnotation Tasks
    var coordinate: CLLocationCoordinate2D {
        
        //Use lets to unwrap and convert the lat/longs from strings to doubles
        //Return generic location if any conversion fails
        guard let currLocation = location,
              let latitude = currLocation.latitude,
              let longitude = currLocation.longitude,
              let latDouble = Double(latitude),
              let longDouble = Double(longitude) else {
            return CLLocationCoordinate2D()
        }
        
        let result = CLLocationCoordinate2D(latitude: latDouble, longitude: longDouble)
        
        return result
    }
}


class Location : JSONModel {
    var latitude : String?
    var longitude : String?
    var needs_recording : Bool?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "needs_recoding" {
            needs_recording = (value as? NSNumber) == 1
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
}

class Website : JSONModel {
    var url : String?
}
