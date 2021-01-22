//
//  ViewController.swift
//  ImageTouch
//
//  Created by Madji on 21.01.21.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var searchBarTextView: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    let imageString = "https://www.talkwalker.com/images/2020/blog-headers/image-analysis.png"
    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func searchButtonTapped(_ sender: Any) {
        
        guard let text = searchBarTextView.text else {
            return
        }
        
        print(text)
        getImage(with: imageString)
        searchBarTextView.text = ""
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let imageToSave = image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    
        if let error = error {
            print(error.localizedDescription)
            
            showAlert(withMessage: "Your image hasn't been saved!", title: "ERROR")
        }
        
        showAlert(withMessage: "Your image has been saved!", title: "Saved")
    
    }
    
}

extension ViewController {

    func getImage(with imageString: String) {
        
        let url = URL(string: imageString)!
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, _) in
            if let data = data {
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self?.imageView.image = image
                        self?.image = image;
                    }
                }
            }
        }
        
        dataTask.resume()
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
