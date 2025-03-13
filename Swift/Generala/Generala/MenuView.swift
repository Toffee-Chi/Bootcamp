//
//  ViewController.swift
//  Generala
//
//  Created by Bootcamp on 2025-03-04.
//

import UIKit

class MenuView: UIViewController {
    
    @IBOutlet weak var buttonBett: UIButton!
    @IBOutlet weak var buttonMore: UIButton!
    @IBOutlet weak var labelSayDon: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        BackgroundMusic.shared.play()
    }

//al tocar el boton de apuesta "BET", se generan los siguientes casos en switch:
    @IBAction func dadosRandom(_ sender: Any) {
        //se crea un array de hasta 5 elementos aleatorios del 1 al 6
        let dados = (1...5).map { _ in Int.random(in: 1...6) }
        print("Números generados: \(dados)") //se commprueba nada mas
        //se pasa a diccionario
        let casos = Dictionary(grouping: dados, by: { $0 }).mapValues { $0.count }

        switch true {
        //el switch se crea por el true porque las condiciones que le brindo son booleanos, el primer case si usa el array y compara si todos son iguales, el segundo para abajo se usa el dictionary para ser mejor condicion.
        case dados.allSatisfy({ $0 == dados.first }):
            labelSayDon.text  = " ¡Se alinearon los astros! Todos los dados son iguales... ¡ES UNA GENERALAAA! 🔥 \(dados)"
            print(" ¡Se alinearon los astros! Todos los dados son iguales... ¡ES UNA GENERALAAA! 🔥 \(dados)")

        case casos.values.contains(4):
            labelSayDon.text  = " ¡Vaya, qué jugada! 4 dados iguales... ¡Has conseguido un POKEER, jugador! 🔥 \(dados)"
            print(" ¡Vaya, qué jugada! 4 dados iguales... ¡Has conseguido un POKEER, jugador! 🔥 \(dados)")

        case casos.values.contains(3) && casos.values.contains(2):
            labelSayDon.text  = " ¡Wow! Un trío y una pareja, ¡qué jugada! ¡Conseguiste una FULL! 🎉🎲 \(dados)"
            //
            print(" ¡Wow! Un trío y una pareja, ¡qué jugada! ¡Conseguiste una FULL! 🎉🎲 \(dados)")
        case dados == [1,2,3,4,5] || dados == [2,3,4,5,6] || dados == [3,4,5,6,1]:
            labelSayDon.text  = " ¡Qué jugada, jugador! ¡Una ESCALERA impresionante! OMG... 🎲💥 \(dados)"
            //
            print("¡Qué jugada, jugador! ¡Una ESCALERA impresionante! OMG... 🎲💥 \(dados)")
        default:
            labelSayDon.text  = " ¡Oh, vaya! Hiciste... absolutamente nada. No te preocupes, ¡intenta de nuevo! 😜🎲 \(dados)"
            //
            print(" ¡Oh, vaya! Hiciste... absolutamente nada. No te preocupes, ¡intenta de nuevo! 😜🎲 \(dados)")
        }
    }

    @IBAction func apostaLA(_ sender: Any) {
        // Aquí defines el enlace que deseas abrir
        if let url = URL(string: "https://www.aposta.la/") {
            // Usamos UIApplication.shared para abrir el enlace
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    
}

