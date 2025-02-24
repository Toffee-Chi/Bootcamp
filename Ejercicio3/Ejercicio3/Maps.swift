//
//  Maps.swift
//  Ejercicio3
//
//  Created by Bootcamp on 2025-02-24.
//

import UIKit
import MapKit

class Maps: UIViewController {
    var mapaView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Inicializar el mapa
        mapaView = MKMapView(frame: view.bounds)
        view.addSubview(mapaView)

        // Coordenadas de la ubicación (Ejemplo: Asunción, Paraguay)
        let latitud: CLLocationDegrees = -25.2637
        let longitud: CLLocationDegrees = -57.5759
        let ubicacion = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)

        // Establecer la región del mapa
        let region = MKCoordinateRegion(center: ubicacion, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapaView.setRegion(region, animated: true)

        // Agregar un pin (marcador)
        let pin = MKPointAnnotation()
        pin.coordinate = ubicacion
        pin.title = "Roshka"
        pin.subtitle = "Tte. Francisco Cusmanich 867, Asunción 1411"
        mapaView.addAnnotation(pin)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
