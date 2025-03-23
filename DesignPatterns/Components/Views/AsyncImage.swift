import UIKit

// PAra cargar las imagenes de forma asíncrona desde la URL
final class AsyncImage: UIImageView {
    var currentWorkItem: DispatchWorkItem?
    
    //Establece la imagen a partir de la URL
    func setImage(_ image: String) {
        if let url = URL(string: image) {
            self.setImage(url)
        }
    }
    
    func setImage(_ image: URL) {
        cancel()
        self.image = UIImage()
        // DispatchWorkItem para gestionar la concurrencia y cancelar la tarea en curso si es necesario
        let workItem = DispatchWorkItem {
            let image = (try? Data(contentsOf: image)).flatMap { UIImage(data: $0) }
            DispatchQueue.main.async { [weak self] in
                self?.image = image ?? UIImage()
                self?.currentWorkItem = nil
            }
        }

        DispatchQueue.global().async(execute: workItem)
        currentWorkItem = workItem
    }
    
    // Cancela la imagen en curso
    func cancel() {
        currentWorkItem?.cancel()
        currentWorkItem = nil
    }
}
