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
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    
    
    var photoImage: UIImage?
    
    let imageString = "https://www.talkwalker.com/images/2020/blog-headers/image-analysis.png"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Determine what the segue destination is
        if segue.destination is EditViewController
        {
            let vc = segue.destination as? EditViewController
            vc?.photoImage = photoImage
        }
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        /*
        let vc = EditViewController(nibName: "EditViewController", bundle: nil)
        vc.photoImage = photoImage
        self.navigationController?.pushViewController(vc, animated: true)
 */
        
        
        
    }
    
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        guard let text = searchBarTextView.text else {
            return
        }
        getImage(with: imageString)
        print(text)        
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
