import CoreData

//Controlador principal para la persistencia de datos usando CoreData
struct PersistenceController {
    
    //Propiedades
    
    // Instancia compartida para uso en toda la aplicación
    static let shared = PersistenceController()
    
    // Instancia para previsualizaciones (usando almacenamiento en memoria)
    @MainActor
    static let preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let contexto = controller.container.viewContext
        
        // Datos de ejemplo para previsualizaciones
        for _ in 0..<10 {
            let nuevoItem = Item(context: contexto)
            nuevoItem.timestamp = Date()
        }
        
        do {
            try contexto.save()
        } catch {
            let errorNSError = error as NSError
            fatalError("Error no resuelto \(errorNSError), \(errorNSError.userInfo)")
        }
        
        return controller
    }()
    
    // Contenedor persistente de CoreData
    let container: NSPersistentContainer
    
    // MARK: - Inicialización
    
    //Inicializa el controlador de persistencia
    // Parameter inMemory: Si es true, usa almacenamiento en memoria (para testing/previews)
    init(inMemory: Bool = false) {
        //Crear contenedor con el nombre del modelo de datos
        container = NSPersistentContainer(name: "AddFluiTH")
        
        //Configurar almacenamiento en memoria si es necesario
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        //Cargar los almacenes persistentes
        container.loadPersistentStores { descripcionAlmacen, error in
            if let error = error as NSError? {
                /*
                 Posibles causas de error:
                 - El directorio padre no existe o no se puede escribir
                 - El almacén no es accesible por permisos
                 - El dispositivo no tiene espacio disponible
                 - No se pudo migrar a la versión actual del modelo
                 */
                
                fatalError("Error no resuelto \(error), \(error.userInfo)")
            }
        }
        
        //Configurar fusión automática de cambios
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    //Métodos de Ayuda
    
    //Guarda los cambios en el contexto
    func guardarContexto() {
        let contexto = container.viewContext
        
        if contexto.hasChanges {
            do {
                try contexto.save()
            } catch {
                let errorNSError = error as NSError
                print("Error al guardar: \(errorNSError), \(errorNSError.userInfo)")
            }
        }
    }
    
    // Elimina todos los items del almacén
    func limpiarBaseDeDatos() {
        let contexto = container.viewContext
        let solicitud = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let borrarSolicitud = NSBatchDeleteRequest(fetchRequest: solicitud)
        
        do {
            try contexto.execute(borrarSolicitud)
            try contexto.save()
        } catch {
            print("Error al limpiar base de datos: \(error)")
        }
    }
}
