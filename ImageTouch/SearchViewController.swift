//
//  SearchViewController.swift
//  ImageTouch
//
//  Created by Madji on 24.01.21.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var searchBarTextView: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    var photoImage: UIImage?
    
    // MARK: - HARD codeed link for image
    var imageString = "https://www.talkwalker.com/images/2020/blog-headers/image-analysis.png"
    
    override func viewDidLoad() {
        
        hideKeyboardWhenTappedAround()
        super.viewDidLoad()
    }
    
    // MARK: - This image will be edited into EditViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is EditViewController
        {
            let vc = segue.destination as? EditViewController
            vc?.photoImage = photoImage
        }
    }
    
    // MARK: - Edit button logic
    @IBAction func editButtonTapped(_ sender: Any) {

    }
    
    // MARK: - Temporayr search tab
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        guard let text = searchBarTextView.text else {
            return
        }
        
        if (text != "") {
            imageString = text
        }
        
        getImage(with: imageString)
//        print(imageString)
        
        searchBarTextView.text = ""
    }
}

extension SearchViewController {
    
    // MARK: - Get image with URL
    private func getImage(with imageString: String) {
        
        let url = URL(string: imageString)!
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, _) in
            if let data = data {
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self?.photoImage = image;
                        self?.photoImageView.image = image
                    }
                }
            }
        }
        
        dataTask.resume()
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
