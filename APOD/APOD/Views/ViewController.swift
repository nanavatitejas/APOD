//
//  ViewController.swift
//  APOD
//
//  Created by Tejas Nanavati on 11/01/23.
//

import UIKit
import AVFoundation
import SafariServices


class ViewController: UIViewController {
    private var isFavorited = false

    
    private var apodViewModel: APODViewModel!
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let explanationTextView = UITextView()
    private let datePicker = UIDatePicker()
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)


    private var favBarButton = UIBarButtonItem()
    private var viewFavBarButton = UIBarButtonItem()



    override func viewDidLoad() {
        super.viewDidLoad()
        apodViewModel = APODViewModel()
        activityIndicator.startAnimating()
        getData(date: Date())
        setUpUi()
      
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        datePicker.datePickerMode = .date
        
        
        favBarButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favButtonTapped))
        
        viewFavBarButton = UIBarButtonItem(title: "View Fav", style: .plain, target: self, action: #selector(viewFavButtonTapped))
        navigationItem.leftBarButtonItem = favBarButton
        navigationItem.rightBarButtonItem = viewFavBarButton
        
        // Do any additional setup after loading the view.
    }
    
    

    @objc private func dateChanged(_ sender: UIDatePicker) {
        getData(date: sender.date)
            
    }
   
    
    
    @objc private func viewFavButtonTapped() {
        let favoritesViewController = FavoritesViewController()
        navigationController?.pushViewController(favoritesViewController, animated: true)
           // toggle the favorite state
          
       }

    @objc private func favButtonTapped() {
           // toggle the favorite state
           isFavorited = !isFavorited
           
           if isFavorited {
               favBarButton.image = UIImage(systemName: "heart.fill")
               apodViewModel.saveAsFavorite()
           } else {
               favBarButton.image = UIImage(systemName: "heart")
               apodViewModel.removeFromFavorite()
           }
       }

    
    func getData(date:Date) {
        
        if NetworkChecker.isConnectedToNetwork() {
            apodViewModel.fetchAPOD(on: date) { [weak self] (result) in
                
                        guard let self = self else { return }
                        switch result {
                        case .success:
                            DispatchQueue.main.async {
                                self.setData()
                                //self.datePicker.isHidden = true

                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()

                            }
                            print(error.localizedDescription)
                            // handle error

                            print(error)
                        }
            }
        } else {
                    apodViewModel.retriveLastSeen()
                    self.setData()
        }


        
    }
   
    
    
    func setData(){
        if apodViewModel.checkFavorites() {
            isFavorited = !isFavorited

            favBarButton.image = UIImage(systemName: "heart.fill")

        } else {
            isFavorited = !isFavorited

            favBarButton.image = UIImage(systemName: "heart")

        }
        activityIndicator.stopAnimating()
        titleLabel.text = apodViewModel.title
        dateLabel.text = apodViewModel.date
        explanationTextView.text = apodViewModel.explanation
        if apodViewModel.mediaType == "video" {

            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(tapGestureRecognizer:)))
            self.imageView.isUserInteractionEnabled = true
            self.imageView.addGestureRecognizer(tapGestureRecognizer)
            let youtubeVideoID = apodViewModel.url.absoluteString.youtubeID
            let id = "https://img.youtube.com/vi/\(youtubeVideoID ?? "")/0.jpg"
            Helper.shared.downloadImage(from: URL(string: id) ?? URL(fileURLWithPath: "")) {  [weak self] image in
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        } else {
            Helper.shared.downloadImage(from: self.apodViewModel.url) {  [weak self] image in
                DispatchQueue.main.async {
                    self?.imageView.image = image
                    self?.imageView.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let safariVC = SFSafariViewController(url: self.apodViewModel.url)
        self.present(safariVC, animated: true, completion: nil)
    }
    
    func setUpUi(){
        // Set up the Activity Indicator
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        // Set up the ImageView
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        // Set up the title label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Set up the date label
        dateLabel.font = UIFont.systemFont(ofSize: 18)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
      
        // Set up the explanation text view
        explanationTextView.isEditable = false
        explanationTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(explanationTextView)
        
        // Set up the date picker
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
       
        // Set up the constraints for the datePicker, image view, title label, date label and explanation text view
        NSLayoutConstraint.activate([
            
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            datePicker.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            datePicker.rightAnchor.constraint(equalTo:view.rightAnchor,constant: -16),
            
            imageView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 16),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            dateLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant:16),
            
            explanationTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            explanationTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            explanationTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            explanationTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
          
        ])
      }
}

