//
//  Model.swift
//  Сhulakov
//
//  Created by Александр Осипов on 21.07.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import Foundation

struct Cat: Decodable {
    let id: String?
    let url: String?
    let width: Int?
    let height: Int?
}
