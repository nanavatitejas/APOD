//
//  APODViewModel.swift
//  APOD
//
//  Created by Tejas Nanavati on 11/01/23.
//

import Foundation


class APODViewModel {

    var apod: APOD?
    private var lastSeen: [LastSeenFav] = []
    private var favorites: [Favorite] = []

    private let context = CoreDataStack.shared.context

    var copyright: String {
        return apod?.copyright ?? ""
    }
    
    var date: String {
        return apod?.date ?? lastSeen.last?.date ?? ""
    }
    
    var explanation: String {
        return apod?.explanation ?? lastSeen.last?.explanation ?? ""
    }
    
    var hdUrl: URL? {
        return apod?.hdurl
    }
    
    var mediaType: String {
        return apod?.mediaType ?? ""
    }
    
    var serviceVersion: String {
        return apod?.serviceVersion ?? ""
    }
    
    var title: String {
        return apod?.title ?? lastSeen.last?.title ?? ""
    }
    
    var url: URL {
        return apod?.url ?? URL(string: (lastSeen.last?.url) ?? "") ?? URL(string: "")!
    }
    

    
    func retriveLastSeen(){
        let fetchRequest = LastSeenFav.fetchRequest()
        do {
            lastSeen = try context.fetch(fetchRequest)
            apod = nil
            
        } catch {
            print("Error fetching favorites: \(error)")
        }
        
    }
    
    func saveLastSeen() {
        guard let apod = self.apod else { return }
        let favorite = LastSeenFav(context: context)
        favorite.date = apod.date
        favorite.explanation = apod.explanation
        favorite.title = apod.title
        favorite.url = apod.url.absoluteString
        favorite.hdurl = apod.hdurl?.absoluteString
        do {
            try context.save()
        } catch {
            print("Error saving the context: \(error)")
        }
    }
    
    
    func saveAsFavorite() {

            guard let apod = self.apod else { return }
            let favorite = Favorite(context: context)
            favorite.date = apod.date
            favorite.explanation = apod.explanation
            favorite.title = apod.title
            favorite.url = apod.url.absoluteString
            favorite.hdurl = apod.hdurl?.absoluteString
            do {
                try context.save()
            } catch {
                print("Error saving the context: \(error)")
            }
    }
    
    
    
    
    func removeFromFavorite() {
        guard let apod = self.apod else { return }
        let dateString = apod.date
        let fetchRequest = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", dateString)
        do {
            let favorites = try context.fetch(fetchRequest)
            if let favorite = favorites.first {
                context.delete(favorite)
                try context.save()
            }
        } catch {
            print("Error removing the favorite: \(error)")
        }
    }
    
    func fetchAPOD(on date: Date, completion: @escaping (Result<APOD, Error>) -> Void) {
        
        API.shared.fetchAPOD(on: date) { (result) in
            switch result {
            case .success(let apod):
                self.apod = apod
                self.saveLastSeen()

                completion(.success(apod))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func checkFavorites()->Bool {
        let fetchRequest = Favorite.fetchRequest()
        do {
            favorites = try context.fetch(fetchRequest)
            for fav in favorites {
                if fav.title == apod?.title {
                    return true
                }
            }
        } catch {
            return false
            print("Error fetching favorites: \(error)")
        }
        return false
    }
    
           
}
