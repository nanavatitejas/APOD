//
//  Network.swift
//  APOD
//
//  Created by Tejas Nanavati on 11/01/23.
//

import Foundation


import Foundation

class API {
    static let shared = API()
    private init() {}

    

    
    func fetchAPOD(on date: Date,completion: @escaping (Result<APOD, Error>) -> Void) {
    
        let dateString = Helper.shared.dateFormatter.string(from: date)

        let urlString = "\(APIConstants.serverURL)/apod?date=\(dateString)&api_key=\(APIConstants.apiKey)"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let error = NSError(domain: "com.example.APOD", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data was not returned from the API"])
                completion(.failure(error))
                return
            }

            do {
                let decoder = JSONDecoder()
                let apod = try decoder.decode(APOD.self, from: data)
                completion(.success(apod))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

