//
//  ViewController.swift
//  Сhulakov
//
//  Created by Александр Осипов on 21.07.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableImagesTabelView: UITableView!
    
    let networking = Networking()
    var catArray: [Cat]?
    
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    @objc private func refresh(sender: UIRefreshControl) {
        networking.downloadImage()
        sender.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networking.delegate = self
        tableImagesTabelView.refreshControl = myRefreshControl
        networking.downloadImage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tableViewCell = sender as! UITableViewCell
        let indexPath = tableImagesTabelView.indexPath(for: tableViewCell)!
        
        if segue.identifier == "ShowImage" {
            let FIVC = segue.destination as! FullImageViewController
            FIVC.cat = catArray![indexPath.row]
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageTableViewCell
        
        configureCell(cell: cell, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cat = catArray![indexPath.row]
        let w = tableView.frame.width / CGFloat(cat.width!)
        let h = CGFloat(cat.height!) * w
        return h
    }
    
    private func configureCell(cell: ImageTableViewCell, for indexPath: IndexPath) {
        let catCell = catArray![indexPath.row]
        cell.activityIndicator.startAnimating()
        cell.imageImageView.image = nil
        DispatchQueue.global(qos: .userInteractive).async {
            guard let urlString = catCell.url else { return }
            guard let url = URL(string: urlString) else { return }
            let image = UIImage(data: try! Data(contentsOf: url))
            DispatchQueue.main.async {
                let cell = self.tableImagesTabelView.cellForRow(at: indexPath) as? ImageTableViewCell
                cell?.imageImageView.image = image
                cell?.activityIndicator.stopAnimating()
            }
        }
    }
}

extension ViewController: PresentModelProtocol {
    
    func presentModel(response: FetchType) {
        switch response {
        case .success(let model):
            catArray = model
            DispatchQueue.main.async {
                self.tableImagesTabelView.reloadData()
            }
        case .failure(let error):
            print(error)
        }
    }
}
