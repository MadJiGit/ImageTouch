//
//  SearchViewController.swift
//  ImageTouch
//
//  Created by Madji on 24.01.21.
//

import UIKit


typealias ImageDownloadResult = (PhotoItem?, Bool) -> Void

class SearchViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var searchBarTextView: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var photoImage: UIImage?
    var photoItems: [PhotoItem] = []
    
    // MARK: - HARD codeed link for image
    var imageString: String?
    let imageString1 = "https://www.talkwalker.com/images/2020/blog-headers/image-analysis.png"
    let imageString2 = "https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg"
    let imageString3 = "https://www.metoffice.gov.uk/binaries/content/gallery/metofficegovuk/hero-images/advice/maps-satellite-images/satellite-image-of-globe.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - This image will be edited into EditViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let editViewController = segue.destination as? EditViewController {
            editViewController.photoImage = photoImage
        }
    }
    
    // MARK: - Temporayr search tab
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        activityIndicatorView.startAnimating()
        
        guard let text = searchBarTextView.text else {
            return
        }
        
        if (text != "") {
            imageString = text
        }
        
        loadAllItems()
        
        print(imageString)
        
        loadPhotoItem(by: text)
        
        searchBarTextView.text = ""
    }
    
    func loadAllItems() {
        loadPhotoItem(by: imageString1)
        loadPhotoItem(by: imageString2)
        loadPhotoItem(by: imageString3)
    }
    
    func loadPhotoItem(by imageURL: String) {
        
        getImage(by: imageURL) { (photoItem, success) in
            
            guard let photoItem = photoItem else {
                print("")
                return
            }
                
            self.photoItems.append(photoItem)
            self.tableView.reloadData()
        }
    }
}

extension SearchViewController {
    
    // MARK: - Get image with URL
    private func getImage(by imageUrlString: String, completion: @escaping ImageDownloadResult ) {
        
        guard let url = URL(string: imageUrlString) else {
            print("Error with URL")
            completion(nil, false)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, _) in
            
            guard let data = data else {
                completion(nil, false)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    var photoItem = PhotoItem()
                    photoItem.image = image
                    photoItem.urlString = imageUrlString
                    completion(photoItem, true)
                } else {
                    completion(nil, false)
                }
            }
        }
        dataTask.resume()
    }
}

extension SearchViewController: UITableViewDelegate {
    
    
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = UITableViewCell()
        
        let item = photoItems[indexPath.row]
        cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath)
        
        if let photoCell = cell as? PhotoTableViewCell {
            photoCell.photoImageView.image = item.image
            photoCell.photoUrlLabel.text = item.urlString
        }
        
        return cell
    }
}

extension UIViewController {
    
    // MARK: - Keyboard Stuff
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    // MARK: - Dismiss keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Show Alert
    func showAlert(withMessage message: String, title: String = "") {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
