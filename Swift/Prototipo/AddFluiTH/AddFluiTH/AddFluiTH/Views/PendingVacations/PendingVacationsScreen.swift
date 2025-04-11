import SwiftUI

struct PendingVacationsScreen: View {
    @State private var vacations: [PendingVacation] = []
    @State private var isLoading: Bool = true
    @State private var showError: Bool = false

    private let dataLoader = PendingVacationsData()
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Cargando vacaciones...")
                } else if showError {
                    Text("Ocurrió un error al cargar los datos.")
                        .foregroundColor(.red)
                        .padding()
                } else if vacations.isEmpty {
                    Text("No hay vacaciones pendientes.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(vacations) { vacation in
                                NavigationLink(destination: VacationDetailScreen(persona: vacation)) {
                                    CardRow(persona: vacation)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Vacaciones Pendientes")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundColor(Color(hex: "#064189"))
                }
            }
            .navigationBarTitleDisplayMode(.inline)

        }
        .onAppear(perform: loadVacations)
    }

    private func loadVacations() {
        dataLoader.fetchPendingVacations { result in
            DispatchQueue.main.async {
                isLoading = false
                if let result = result {
                    vacations = result
                } else {
                    showError = true
                }
            }
        }
    }
}

#Preview {
    PendingVacationsScreen()
}
