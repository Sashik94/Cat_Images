//
//  Networking.swift
//  Сhulakov
//
//  Created by Александр Осипов on 21.07.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import Foundation

protocol PresentModelProtocol {
    func presentModel(response: FetchType)
}

enum FetchType {
    case success(model: [Cat])
    case failure(error: String)
}

class Networking {
    
    var delegate: PresentModelProtocol?
    let url = URL(string: "https://api.thecatapi.com/v1/images/search?size=thumb&limit=100")!
    
    func downloadImage() {
        getData(from: url) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let tracks = try JSONDecoder().decode([Cat].self, from: data)
                    self!.delegate?.presentModel(response: .success(model: tracks))
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    self!.delegate?.presentModel(response: .failure(error: jsonError.localizedDescription))
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                self!.delegate?.presentModel(response: .failure(error: error.localizedDescription))
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            completion(.success(data))
        }.resume()
    }
}
