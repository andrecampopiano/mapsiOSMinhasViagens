//
//  MapViewController.swift
//  Minhas Viagens
//
//  Created by André Luís  Campopiano on 23/02/17.
//  Copyright © 2017 André Luís  Campopiano. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var managerLocation = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configManagerLocation()
        
        let recognizeGestures = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.mark(gesture:)))
        
            recognizeGestures.minimumPressDuration = 1
        
        mapView.addGestureRecognizer(recognizeGestures)
    
        
    }
    
    func mark(gesture: UIGestureRecognizer){
        
        if gesture.state == UIGestureRecognizerState.began {
            //Recuperar a coordenada do ponto selecionado
            let selectedPoint = gesture.location(in: self.mapView)
            let coordinates = mapView.convert(selectedPoint, toCoordinateFrom: self.mapView)
            
            //Exibe anotações com os dados de endereco
            let annotation = MKPointAnnotation()
            
            annotation.coordinate.latitude = coordinates.latitude
            annotation.coordinate.longitude = coordinates.longitude
            annotation.title = "Ponto Selecionado"
            annotation.subtitle = "Selecionou aqui"
            
            mapView.addAnnotation(annotation)
            
        }
        
        
    }

    func configManagerLocation(){
        managerLocation.delegate = self
        managerLocation.desiredAccuracy = kCLLocationAccuracyBest
        managerLocation.requestWhenInUseAuthorization()
        managerLocation.startUpdatingLocation()

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse{
            let alertController = UIAlertController(title: "Permissâo de localização", message: "Necessario permissão para acesso à sua localização, por favor habilite", preferredStyle: .alert)
            let actionConfig = UIAlertAction(title: "Abrir Configurações", style: .default, handler: { (alertConfig) in
                if let config = NSURL(string: UIApplicationOpenSettingsURLString){
                    UIApplication.shared.open(config as URL)
                }
            })
            
            let actionCancel = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            alertController.addAction(actionConfig)
            alertController.addAction(actionCancel)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
