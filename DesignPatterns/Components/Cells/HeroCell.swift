import UIKit

//Celda reutilizable para mostrar la info del heroe en una tabla
final class HeroCell: UITableViewCell {
    static let reuseIdentifier = "HeroCell"
    static let height: CGFloat = 90
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarView: AsyncImage!
    
    // Configura la celda
    func setData(name: String, photo: String) {
        nameLabel.text = name
        avatarView.setImage(photo)
    }
}
