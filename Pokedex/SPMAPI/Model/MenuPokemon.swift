import UIKit
import Foundation
import Alamofire
import Kingfisher

class MenuPokemon: UIViewController {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var habilidad: UILabel!
    @IBOutlet weak var peso: UILabel!
    @IBOutlet weak var tipo: UILabel!
    
    @IBOutlet weak var campoText: UITextField!  // Campo de entrada de datos
    @IBOutlet weak var pickerTextField: UITextField! // Campo asociado al PickerView
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var image1: UIImageView!
    
    //inicializamos las variables del picker
    let pickerView = UIPickerView()
    let opciones = ["Nombre", "ID"]
    var criterioSeleccionado = "Nombre"  // Opción por defecto
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BackgroundMusic.shared.play()
        
        // Configurar PickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Asignar PickerView al campo pickerTextField
        pickerTextField.inputView = pickerView
        pickerTextField.text = "Nombre" // Opción por defecto
        
        // Configurar campoText
        campoText.placeholder = "Ingrese un nombre"
        campoText.keyboardType = .default
        campoText.delegate = self // Para ocultar teclado con "Enter"
    }
    
    @IBAction func buscarPokemon(_ sender: UIButton) {
        guard let textoBusqueda = campoText.text?.lowercased(), !textoBusqueda.isEmpty else {
            titulo.text = "Introduce un \(criterioSeleccionado.lowercased())"
            return
        }
        
        let url = "https://pokeapi.co/api/v2/pokemon/\(textoBusqueda)"
        
        
        
        AF.request(url).responseDecodable(of: Pokemon.self) { response in
            switch response.result {
            case .success(let pokemon):
                DispatchQueue.main.async {
                    self.titulo.text = "Nombre: \(pokemon.name.capitalized)"
                    
                    // Habilidad especial
                    if let habilidadEspecial = pokemon.abilities.first?.ability.name {
                        self.habilidad.text = "Habilidad: \(habilidadEspecial.capitalized)"
                    } else {
                        self.habilidad.text = "Habilidad: No disponible"
                    }
                    
                    // Peso del Pokémon
                    self.peso.text = "Peso: \(pokemon.weight / 10) kg"
                    
                    // Tipo de Pokémon
                    if let tipo = pokemon.types.first?.type.name {
                        self.tipo.text = "Tipo: \(tipo.capitalized)"
                    } else {
                        self.tipo.text = "Tipo: No disponible"
                    }
                    
                    // Cargar imagen con Kingfisher en HD
                    //                    if let imageUrl = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemon.id).png") {
                    //                        self.image1.kf.setImage(with: imageUrl)
                    //                    }
                    //image default de pokeapi
                    if let imageUrl = URL(string: pokemon.sprites.frontDefault ?? "") {
                        self.image1.kf.setImage(with: imageUrl) // Usando Kingfisher para cargar la imagen
                    }
                    
                }
            case .failure:
                DispatchQueue.main.async {
                    self.titulo.text = "Error: No encontrado"
                    self.habilidad.text = "Habilidad: -"
                    self.peso.text = "Peso: -"
                    self.tipo.text = "Tipo: -"
                }
            }
        }
    }
}

//UIPickerView Delegate & DataSource
extension MenuPokemon: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return opciones.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return opciones[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        criterioSeleccionado = opciones[row] // Guardamos la opción seleccionada
        pickerTextField.text = criterioSeleccionado // Mostrar en el campo de texto del picker
        
        // Cambiar el teclado según la opción seleccionada
        if criterioSeleccionado == "Nombre" {
            campoText.keyboardType = .default // Teclado alfabético
            campoText.placeholder = "Ingrese un nombre"
        } else {
            campoText.keyboardType = .numberPad // Teclado numérico
            campoText.placeholder = "Ingrese un ID"
        }
        
        campoText.reloadInputViews() // Actualizar el teclado
        pickerTextField.resignFirstResponder() // Cerrar el picker después de seleccionar
    }
}

//UITextFieldDelegate para ocultar el teclado con "Enter"
extension MenuPokemon: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Cierra el teclado al presionar "Enter"
        return true
    }
}
