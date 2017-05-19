//
//  DetailViewController.swift
//  ChicagoLibraries
//
//  Created by James Klitzke on 1/28/17.
//  Copyright © 2017 James Klitzke. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {


    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var libraryNameLabel: UILabel!
    @IBOutlet weak var libraryAddressLabel: UILabel!
    @IBOutlet weak var libraryHoursLabel: UILabel!

    var library: Library?
    
    let regionRadius: CLLocationDistance = 300
    
    func configureView() {
        
        guard let library = library else {
            libraryNameLabel.text = ""
            libraryAddressLabel.text = ""
            libraryHoursLabel.text = ""
            return
        }
        
        libraryNameLabel.text = library.name_
        libraryNameLabel.sizeToFit()
        libraryAddressLabel.text = library.address
        libraryHoursLabel.text = library.hours_of_operation
        
        centerMapOnLocation(location: library.coordinate)
        mapView?.showAnnotations([library], animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        self.mapView.delegate = self
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion =
            MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension DetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Library else {
            return nil
        }
        
        let identifier = "pin"
        var view: MKPinAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
        else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = false
        }
        return view
    }
}
