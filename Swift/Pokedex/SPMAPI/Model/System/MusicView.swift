import Foundation
import AVFoundation

class BackgroundMusic {
    static let shared = BackgroundMusic() // Singleton
    var audioPlayer: AVAudioPlayer?
    private init() {} // Evita que se creen múltiples instancias
    func play() {
        if audioPlayer == nil { // Solo lo inicializa si no está en uso
            guard let path = Bundle.main.path(forResource: "pokemon", ofType: "mp3") else {
                print("No se encontró el archivo de audio")
                return
            }
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = -1 // Repetir infinito
                audioPlayer?.play()
            } catch {
                print("Error al reproducir el audio: \(error.localizedDescription)")
            }
        }
    }
    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil // Libera la memoria
    }
}

