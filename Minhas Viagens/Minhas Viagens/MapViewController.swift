//
//  MapViewController.swift
//  Minhas Viagens
//
//  Created by André Luís  Campopiano on 23/02/17.
//  Copyright © 2017 André Luís  Campopiano. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var managerLocation = CLLocationManager()
    var viagem:Dictionary<String, String> = [:]
    var indexSelected:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let index = indexSelected {
            if index == -1 {//adicionar
                self.configManagerLocation()
            }else{//listar
                self.showAnnotation(viagem: viagem)
                
            }
        }
        
        //reconhecedor de gestos
        let recognizeGestures = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.mark(gesture:)))
        
            recognizeGestures.minimumPressDuration = 1
        
        mapView.addGestureRecognizer(recognizeGestures)
    
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        self.showLocal(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func showLocal(latitude:Double, longitude:Double){
        let local = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(local, span)
        self.mapView.setRegion(region, animated: true)
    }
    
    func showAnnotation(viagem: Dictionary<String,String>){
        
        //Exibe anotações com os dados de endereco
        let annotation = MKPointAnnotation()
        let latitude = Double(viagem["latitude"]!)!
        let longitude = Double(viagem["longitude"]!)!
        annotation.coordinate.latitude = latitude
        annotation.coordinate.longitude = longitude
        annotation.title = viagem["local"]
        
        self.mapView.addAnnotation(annotation)
        
        showLocal(latitude: latitude, longitude: longitude)
        

    }
    
    
    
    func mark(gesture: UIGestureRecognizer){
        
        if gesture.state == UIGestureRecognizerState.began {
            //Recuperar a coordenada do ponto selecionado
            let selectedPoint = gesture.location(in: self.mapView)
            let coordinates = mapView.convert(selectedPoint, toCoordinateFrom: self.mapView)
            
            let localization = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
    
            //Recuperar endereço do local selecionado
            var placeFull = "Endereço não encontrado."
            
            CLGeocoder().reverseGeocodeLocation(localization, completionHandler: { (place, error) in
               
                if error == nil{
                    
                    if let localData = place?.first {
                        
                        if let name = localData.name{
                            placeFull = name
                        }else {
                            if let address = localData.thoroughfare {
                                placeFull = address
                            }
                        }
                    }
                    
                    
                    //Salvar dados no dispositivo
                    self.viagem = ["local":placeFull, "latitude":String(coordinates.latitude), "longitude":String(coordinates.longitude)]
                    DataStorage().saveTravel(viagem: self.viagem)

                    
                    //Exibe anotações com os dados de endereco
                    self.showAnnotation(viagem: self.viagem)
                    
                }else{
                    print(error)
                }
            })
            
            
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
