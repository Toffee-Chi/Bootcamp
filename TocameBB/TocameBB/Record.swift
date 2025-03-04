import UIKit

class Record: UIViewController {

    @IBOutlet weak var recordLabel: UILabel!
    

        
    override func viewDidLoad() {
        super.viewDidLoad()
        if let datosRecuperados = UserDefaults.standard.array(forKey: "todo") as? [[String: String]] {

            
            // Usar los datos
            print(datosRecuperados)
            mostrarTop5Puntajes()
        }
    }
 
    func mostrarTop5Puntajes() {
        guard let registros = UserDefaults.standard.array(forKey: "todo") as? [[String: String]] else {
            recordLabel.text = "🏆 Aún no hay puntajes"
            return
        }
        
        let registrosOrdenados = registros.sorted {
            (Int($0["Score"] ?? "0") ?? 0) > (Int($1["Score"] ?? "0") ?? 0)
        }
        
        let top5 = registrosOrdenados.prefix(5)
        
        let attributedString = NSMutableAttributedString()
        
        // Título con estilo
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.white
        ]
        attributedString.append(NSAttributedString(string: "🏆 Top 5 Puntajes 🏆\n\n", attributes: titleAttributes))
        
        // Añadir cada puntaje
        for (index, registro) in top5.enumerated() {
            let nombre = registro["Nombre"] ?? "Desconocido"
            let puntaje = registro["Score"] ?? "0"
            
            let rankAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 16),
                .foregroundColor: UIColor.white
            ]
            
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.white
            ]
            
            attributedString.append(NSAttributedString(string: "\(index + 1). ", attributes: rankAttributes))
            attributedString.append(NSAttributedString(string: "\(nombre): ", attributes: textAttributes))
            attributedString.append(NSAttributedString(string: "\(puntaje) puntos\n", attributes: textAttributes))
        }
        
        recordLabel.attributedText = attributedString
        recordLabel.numberOfLines = 0
        recordLabel.lineBreakMode = .byWordWrapping
    }
}
