//
//  ViewController.swift
//  Ejercicio3
//
//  Created by Bootcamp on 2025-02-24.
//

import UIKit

class Login: UIViewController {
    
    @IBOutlet weak var LabelTitle: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPass: UILabel!
    @IBOutlet weak var LabelContacto: UILabel!
    @IBOutlet weak var LabelUbi: UILabel!
    @IBOutlet weak var buttonIngresa: UIButton!
    @IBOutlet weak var textfieldName: UITextField!
    @IBOutlet weak var LabelPolitica: UILabel!
    @IBOutlet weak var textfieldPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Deshabilitar botón al inicio
        buttonIngresa.isEnabled = false
        
        // Agregar acción a los textFields para detectar cambios
        textfieldName.addTarget(self, action: #selector(verificarCampos), for: .editingChanged)
        textfieldPass.addTarget(self, action: #selector(verificarCampos), for: .editingChanged)
    }

    @objc func verificarCampos() {
        let Usuariostring = textfieldName.text ?? ""
        let Contraseña = textfieldPass.text ?? ""

        // Habilita el botón si ambos textFields tienen texto
        buttonIngresa.isEnabled = !Usuariostring.isEmpty && !Contraseña.isEmpty
    }

    @IBAction func botonPresionado(_ sender: UIButton) {
        print("¡Botón presionado!")
    }
        
        
    }


