import SwiftUI
import SwiftData
import Kingfisher

struct LeaveListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var leaves: [LeaveRequest]

    @State private var showingAddView = false // Consider removing if unused
    @State private var expandedLeaveID: PersistentIdentifier? = nil

    // Main View Body
    var body: some View {
        NavigationStack {
            VStack { // Root view inside NavigationStack
                Group {
                    if leaves.isEmpty {
                        emptyListView // Use extracted computed property
                    } else {
                        leaveListContent // Use extracted computed property
                    }
                }
                // Apply toolbar to the VStack content
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        NavigationLink(destination: LeaveFormView(viewModel: LeaveViewModel())) {
                                     Image(systemName: "plus")
                                 }
                    }
                }
                // Apply navigation title to the content within NavigationStack
                .navigationTitle("Solicitudes")
            } // End VStack
        } // End NavigationStack
    } // End body

    // MARK: - Computed Views (Private Helper Views)

    // Extracted view for the empty state
    private var emptyListView: some View {
        ContentUnavailableView(
            "No hay solicitudes",
            systemImage: "doc.text",
            description: Text("Agregue una nueva solicitud")
        )
    }

    // Extracted computed property for the list content
    private var leaveListContent: some View {
        List {
            ForEach(leaves) { leave in
                LeaveCardView(
                    leave: leave,
                    isExpanded: expandedLeaveID == leave.persistentModelID,
                    onTap: {
                        handleTap(on: leave) // Call helper function
                    }
                )
                .swipeActions {
                    Button(role: .destructive) {
                        deleteLeave(leave)
                    } label: {
                        Label("Eliminar", systemImage: "trash")
                    }
                }
            }
        }
        // Ensure List styling (like .listStyle) is applied here if needed
    }

    // MARK: - Helper Functions

    // Helper function for tap action
    private func handleTap(on leave: LeaveRequest) {
        withAnimation {
            if expandedLeaveID == leave.persistentModelID {
                expandedLeaveID = nil
            } else {
                expandedLeaveID = leave.persistentModelID
            }
        }
    }

    // Helper function for deleting
    private func deleteLeave(_ leave: LeaveRequest) {
        modelContext.delete(leave)
        // Consider adding error handling if modelContext.save() is needed
        // try? modelContext.save()
    }

} // MARK: - End LeaveListView Struct


// MARK: - Preview

#Preview {
     // Using MainContainerView as it likely provides the necessary environment, including the model container
     MainContainerView(onLogout: {})
        .modelContainer(for: LeaveRequest.self, inMemory: true)
}
