//
//  FavoritesViewController.swift
//  APOD
//
//  Created by Tejas Nanavati on 17/01/23.
//

import Foundation
import UIKit

class FavoritesViewController: UITableViewController {
    private let context = CoreDataStack.shared.context
    private var favorites: [Favorite] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .singleLine
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: "FavoriteCell")
        self.title = "Favorites"
        fetchFavorites()
    }
   
    private func fetchFavorites() {
        let fetchRequest = Favorite.fetchRequest()
        do {
            favorites = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error fetching favorites: \(error)")
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 70
      }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteTableViewCell
        let favorite = favorites[indexPath.row]
        cell.setData(favorite: favorite)
        return cell
    }
}

