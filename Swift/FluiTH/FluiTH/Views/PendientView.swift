import SwiftUI

struct PendingView: View {
    var body: some View {
        Text("Vista de Pendientes")
            .font(.largeTitle)
            .navigationTitle("Solicitudes Pendientes")
    }
}

struct PendingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PendingView()
        }
    }
}
