//
//  ReviewCell.swift

import UIKit

class ReviewCell: UICollectionViewCell {
    
    @IBOutlet  private weak var userImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userImageView.image = nil
    }
    
    func fill(_ review: Review) {
        userImageView.image = review.image
    }
}
