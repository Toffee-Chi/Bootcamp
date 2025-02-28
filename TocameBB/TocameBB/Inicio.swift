import UIKit

class Inicio: UIViewController {
    //inicializan las variables que se van a utilizar para funciones o edicion
    @IBOutlet weak var HomeButton: UIButton!
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var FoolButton: UIButton!
    @IBOutlet weak var FoolGround: UIView!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    var nombre: String!

    var count = 0  // Variable para almacenar el contador del juego
    var timer: Timer? // inicializando el dato
    var seconds = 7  // Tiempo máximo en segundos
    var isGameActive = false  // Flag para controlar si el juego está activo o no
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Llamar al timer para que se mueva el botón solo cuando el juego esté activo
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.isGameActive {
                self.moveButtonRandomly()
            }
        }

        TimeLabel.text = "\(seconds)"  // Inicializa el label con 30
        ScoreLabel.text = "\(count)"  // Inicializa el label en 0
    }


    

    
    @IBAction func moveButtonTapped(_ sender: UIButton) {
        moveButtonRandomly()
    }
    
    // Función para mover el botón en posiciones aleatorias
    func moveButtonRandomly() {
        let maxX = FoolGround.frame.width - FoolButton.frame.width - 30
        let maxY = FoolGround.frame.height - FoolButton.frame.height - 90
        
        let randomX = CGFloat.random(in: 0...maxX)
        let randomY = CGFloat.random(in: 0...maxY)
        
        UIView.animate(withDuration: 0.3) {
            self.FoolButton.frame.origin = CGPoint(x: randomX, y: randomY)
        }
    }
    
    // Función para incrementar el contador
    @IBAction func countButtonTapped(_ sender: UIButton) {
        if sender == FoolButton {
            count += 1
            ScoreLabel.text = "\(count)"
        }
    }
    //cuando se toca el boton start, se mueve el boton dinamico y se reinicia el contador
    @IBAction func startButtonTapped(_ sender: UIButton) {
        count = 0
        ScoreLabel.text = "\(count)"
        sender.isEnabled = false
        startTimer()
        isGameActive = true
    }

    // Función para iniciar el temporizador
    func startTimer() {
        timer?.invalidate()
        seconds = 30
        TimeLabel.text = "\(seconds)"
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    // Función para actualizar el temporizador
    @objc func updateTimer() {
        if seconds > 0 {
            seconds -= 1
            TimeLabel.text = "\(seconds)"
        } else {
            timer?.invalidate()
           // saveScore()
            showAlert()
            count = 0
            ScoreLabel.text = "\(count)"
            isGameActive = false
        }
    }

    // Función para mostrar la alerta
    func showAlert() {
        let alert = UIAlertController(title: "¡Tiempo terminado!", message: "Tu puntaje es: \(count)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sopas!!", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        saveScore()
    }
//almacena los datos del usuario, y envia al record el historial de los mismos
    func saveScore(){
       /* if let score = ScoreLabel.text {
            UserDefaults.standard.set(score, forKey: "Score")
        }*/
        var Usuarios: [String: String] = [:] // Crear un diccionario vacío
        Usuarios["Nombre"] = nombre // Guardar un String en el diccionario
        
        var Score: [String: String] = [:] // Crear un diccionario vacío
        Score["Score"] = ScoreLabel.text ?? "" // Guardar un String en el diccionario
 
        let todo = [Usuarios, Score]
        UserDefaults.standard.set(todo, forKey: "todo")
        
    }
    //manda el default donde tiene todos los datos

}
