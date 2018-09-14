

import UIKit

class CategoryLocationTVCell: UITableViewCell {
    
    var spot: Spot? {
        didSet {
            if let spot = spot {
                if let url = URL(string: spot.images[0].image) {
                    imgView.kf.setImage(with: url)
                }
                nameLabel.text = spot.name
            }
        }
    }

    var currentCategory: String? {
        didSet {
            if let category = currentCategory {
                categoryLabel.text = category.count > 0 ? "# " + category : ""
            }
        }
    }
    
    @IBOutlet private weak var centerLineView: UIView! {
        didSet {
            centerLineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        }
    }
    
    @IBOutlet private weak var imgView: UIImageView! {
        didSet {
            imgView.clipsToBounds = true
            imgView.layer.cornerRadius = 7.5
            imgView.contentMode = .scaleAspectFill
            imgView.kf.indicatorType = .activity
        }
    }
    
    @IBOutlet private weak var nameLabel: UILabel! {
        didSet {
            nameLabel.textAlignment = .left
            nameLabel.numberOfLines = 2
            nameLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        }
    }
    
    @IBOutlet private weak var categoryLabel: UILabel! {
        didSet {
            categoryLabel.textAlignment = .left
            categoryLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
            categoryLabel.textColor = UIColor.gray
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectionStyle = .none
        backgroundColor = UIColor.clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = ""
        categoryLabel.text = ""
        imgView.image = nil
    }
}

