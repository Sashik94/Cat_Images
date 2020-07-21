//
//  ImageTableViewCell.swift
//  Сhulakov
//
//  Created by Александр Осипов on 21.07.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let cache = NSCache<AnyObject,AnyObject>()
    
    var model: Cat! {
        didSet {
            downloadImage(cat: model)
        }
    }
    
    func downloadImage(cat: Cat) {
        
        guard let urlString = cat.url else { return }
        guard let url = URL(string: urlString) else { return }
        
        if let image = cache.object(forKey: urlString as AnyObject) as? UIImage{
            DispatchQueue.main.async {
                self.imageImageView.image = image
                self.activityIndicator.stopAnimating()
            }
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            let image = UIImage(data: try! Data(contentsOf: url))
            self.cache.setObject(image!, forKey: urlString as AnyObject)
            DispatchQueue.main.async {
                self.imageImageView.image = image
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
