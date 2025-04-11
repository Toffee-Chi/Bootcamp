import SwiftUI
import UIKit

struct Help: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Documentación de Ayuda")
                .font(.title2)
                .bold()
            
            Button(action: {
                downloadPDF()
            }) {
                Label("Descargar PDF", systemImage: "arrow.down.doc")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
    }

    private func downloadPDF() {
        guard let url = Bundle.main.url(forResource: "DocumentacionFluiTH", withExtension: "pdf") else {
            print("❌ No se encontró el PDF en el bundle.")
            return
        }
        
        let tempDir = FileManager.default.temporaryDirectory
        let destinationURL = tempDir.appendingPathComponent("DocumentacionFluiTH.pdf")

        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            try FileManager.default.copyItem(at: url, to: destinationURL)
            showShareSheet(url: destinationURL)
        } catch {
            print("❌ Error al copiar el archivo:", error)
        }
    }

    private func showShareSheet(url: URL) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = scene.windows.first?.rootViewController else {
            return
        }

        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        rootVC.present(activityVC, animated: true, completion: nil)
    }
}
