import SwiftUI

struct AprovedView: View {
    @State private var vacations: [ApprovedVacation] = []
    @State private var isLoading: Bool = true
    @State private var showError: Bool = false

    private let dataLoader = ApprovedVacationsData()

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Cargando aprobados...")
                } else if showError {
                    Text("Ocurrió un error al cargar los datos.")
                        .foregroundColor(.red)
                        .padding()
                } else if vacations.isEmpty {
                    Text("No hay vacaciones aprobadas.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(vacations) { vacation in
                                NavigationLink(destination: VacationDetailApprovedScreen(persona: vacation)) {
                                    CardRowAprobado(persona: vacation)
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
                    Text("Vacaciones Aprobadas")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundColor(Color.green)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(perform: loadVacations)
    }

    private func loadVacations() {
        dataLoader.fetchApprovedVacations { result in
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

