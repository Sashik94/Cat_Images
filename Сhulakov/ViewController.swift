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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networking.delegate = self
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
        
        cell.activityIndicator.startAnimating()
        let cat = catArray![indexPath.row]
        cell.model = cat
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cat = catArray![indexPath.row]
        let w = tableView.frame.width / CGFloat(cat.width!)
        let h = CGFloat(cat.height!) * w
        return h
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
