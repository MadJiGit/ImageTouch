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
    
    var photoImage: UIImage?
    var photoItems: [PhotoItem] = []
    
    // MARK: - HARD codeed link for image
    var imageString = ""
    let imageString1 = "https://www.talkwalker.com/images/2020/blog-headers/image-analysis.png"
    let imageString2 = "https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg"
    let imageString3 = "https://www.metoffice.gov.uk/binaries/content/gallery/metofficegovuk/hero-images/advice/maps-satellite-images/satellite-image-of-globe.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBarTextView.delegate = self
    }
    
    
    // MARK: - This image will be edited into EditViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let editViewController = segue.destination as? EditViewController {
            editViewController.photoImage = photoImage
        }
    }
    
    // MARK: - Temporary search tab
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        guard let text = searchBarTextView.text else {
            return
        }
        
        if (text != "") {
            imageString = text
        }
        
        loadAllItems()
        
        searchBarTextView.text = ""
    }
    
    // MARK: - Method to load all images
    func loadAllItems() {
        loadPhotoItem(by: imageString)
        loadPhotoItem(by: imageString1)
        loadPhotoItem(by: imageString2)
        loadPhotoItem(by: imageString3)
    }
    
    // MARK: - Load images one by one 
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
    
    // MARK: - Calculate height of cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        let scaldeSize = photoItems[indexPath.row].scaledSize
        
        return scaldeSize.height + 10 // Top + Bottom margins
    }
    
    // MARK: - Prepare image for sending to edit scene
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        photoImage = photoItems[indexPath.row].image
        performSegue(withIdentifier: "SearchToEditScene", sender: nil)
    }
}

extension SearchViewController: UITableViewDataSource {
    
    // MARK: - TableView methods
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


extension SearchViewController: UITextFieldDelegate {
    
    // MARK: - Keyboard - method to hide keyboard when hit return button on it
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension UIViewController {
    
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
