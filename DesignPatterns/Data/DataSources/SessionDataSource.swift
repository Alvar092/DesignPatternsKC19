import Foundation

// Metodos para almacenar y recuperar los datos de sesion
protocol SessionDataSourceProtocol {
   // Almacena la sesión proporcionada
    func storeSession(_ session: Data?)
    
    // Para recuperar los datos de la sesión almacenada
    func getSession() -> Data?
}

// Acoge al protocolo y gestiona el token y se crea una instancia siguiendo un Singleton
final class SessionDataSource: SessionDataSourceProtocol {
    static let shared: SessionDataSourceProtocol = SessionDataSource()
    
    private var token: Data?
    
    func storeSession(_ session: Data?) {
        self.token = session
    }
    
    func getSession() -> Data? {
        return self.token
    }
}
