import UIKit
import AVFoundation
import AVKit

class Menu: UIViewController {
    
    @IBOutlet weak var InicioButton: UIButton!
    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var MoreButton: UIButton!
    
    // Agregar una variable para mantener referencia al playerLayer
    private var playerLayer: AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Looks for single or multiple taps.
        BackgroundMusic.shared.play() // Se asegura de que la música suene

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Habilitar el botón de inicio si el texto no está vacío
        updateStartButtonState()
        
        // Agregar un target para detectar cambios en el textField
        nameText.addTarget(self, action: #selector(NameTextChange), for: .editingChanged)
    }
    
    // Función que habilita/deshabilita el botón de inicio
    func updateStartButtonState() {
        // Habilita el botón de inicio solo si el campo de texto no está vacío
        InicioButton.isEnabled = !(nameText.text?.isEmpty ?? true)
    }
    
    // Llamado cuando el texto cambia en el textField
    @objc func NameTextChange() {
        // Actualiza el estado del botón de inicio
        updateStartButtonState()
    }
    
    // Llamado cuando el tap se reconoce
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // Recuperar el array actual o crear uno nuevo si no existe
        var nombreArray = UserDefaults.standard.stringArray(forKey: "NombreArray") ?? []
        
        // Agregar el nuevo nombre
        if let nuevoNombre = nameText.text, !nuevoNombre.isEmpty {
            // Limitar a los últimos 5 nombres por ejemplo
            if nombreArray.count >= 5 {
                nombreArray.removeFirst()
            }
            nombreArray.append(nuevoNombre)
        }
        
        // Guardar el array actualizado
        UserDefaults.standard.set(nombreArray, forKey: "NombreArray")
        
        print("Nombres guardados: \(nombreArray)")

    }
    
    @IBAction func More(_ sender: UIButton) {
        // Aquí defines el enlace que deseas abrir
        if let url = URL(string: "https://www.cartoonnetwork.co.uk/games") {
            // Usamos UIApplication.shared para abrir el enlace
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
