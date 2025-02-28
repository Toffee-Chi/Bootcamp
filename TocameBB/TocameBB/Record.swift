import UIKit

class Record: UIViewController {

    @IBOutlet weak var recordLabel: UILabel!
    

        
    override func viewDidLoad() {
        super.viewDidLoad()
        if let datosRecuperados = UserDefaults.standard.array(forKey: "todo") as? [[String: String]] {
            let primerDiccionario = datosRecuperados[0]
            let segundoDiccionario = datosRecuperados[1]
            
            // Usar los datos
            print(datosRecuperados)
            print(primerDiccionario["Nombre"] ?? "")
            print(segundoDiccionario["Score"] ?? "")
        }
    }
 

}
