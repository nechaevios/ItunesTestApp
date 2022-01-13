//
//  SongsModel.swift
//  ItunesTestApp
//
//  Created by Nechaev Sergey  on 13.01.2022.
//

import Foundation

struct SongsModel: Decodable {
    let results: [Song]
}

struct Song: Decodable {
    let trackName: String?
}
