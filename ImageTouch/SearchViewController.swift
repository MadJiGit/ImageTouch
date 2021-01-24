//
//  SearchViewController.swift
//  ImageTouch
//
//  Created by Madji on 24.01.21.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBarTextView: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    let imageString = "https://www.talkwalker.com/images/2020/blog-headers/image-analysis.png"

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        guard let text = searchBarTextView.text else {
            return
        }
        
        print(text)        
        searchBarTextView.text = ""
    }
    
    // MARK: - Get image with URL
    func getImage(with imageString: String) {
        
        let url = URL(string: imageString)!
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, _) in
            if let data = data {
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self?.image = image;
                    }
                }
            }
        }
        
        dataTask.resume()
    }

}
