//
//  NetworkManager.swift
//  ItunesTestApp
//
//  Created by Nechaev Sergey  on 12.01.2022.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchSong(urlString: String, completion: @escaping (SongsModel?, Error?) -> Void) {
        fetchData(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let songs = try JSONDecoder().decode(SongsModel.self, from: data)
                    completion(songs, nil)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error received: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
    
    func fetchAlbum(urlString: String, completion: @escaping (AlbumModel?, Error?) -> Void) {
        fetchData(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let albums = try JSONDecoder().decode(AlbumModel.self, from: data)
                    completion(albums, nil)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error received: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
    
    func fetchData(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }
        .resume()
    }
}
