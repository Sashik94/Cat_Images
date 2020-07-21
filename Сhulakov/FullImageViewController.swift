//
//  FullImageViewController.swift
//  Сhulakov
//
//  Created by Александр Осипов on 22.07.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var cat: Cat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        guard let urlString = cat?.url else { return }
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global(qos: .userInteractive).async {
            let image = UIImage(data: try! Data(contentsOf: url))
            DispatchQueue.main.async {
                self.mainImageView.image = image
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
