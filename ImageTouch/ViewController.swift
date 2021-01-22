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
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var brightnessLabel: UILabel!
    @IBOutlet weak var sliderValueLabel: UILabel!
    
    let imageString = "https://www.talkwalker.com/images/2020/blog-headers/image-analysis.png"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSliders()
    }

    @IBAction func brightnessSliderMoved(_ sender: UISlider) {
        print("\(sender.value)")
        imageBrightness(imgView: imageView, sliderValue: CGFloat(sender.value), image: image!)
        sliderValueLabel.text = String(format: "%@.2d", sender.value)
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        guard let text = searchBarTextView.text else {
            return
        }
        
        print(text)
        getImage(with: imageString)
        showImage(with: image)
        
        searchBarTextView.text = ""
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let imageToSave = imageView.image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
}

// MARK: - Edit image tools
extension ViewController {
    
    private func invertSlidersVisibility() {
        brightnessLabel.isHidden = !brightnessLabel.isHidden
        brightnessSlider.isHidden = !brightnessSlider.isHidden
    }
    
    private func setSliders() {
        invertSlidersVisibility()
//        brightnessSlider.minimumValue = 0.0
//        brightnessSlider.maximumValue = 0.0
        brightnessSlider.value = 0.0
        sliderValueLabel.text = String(format: "%@.2d", brightnessSlider.value)
    }
    
    func imageBrightness(imgView : UIImageView , sliderValue : CGFloat, image: UIImage){
        
        guard let aCGImage = image.cgImage else {
            return
        }
        
        let aCIImage = CIImage(cgImage: aCGImage)
        let context = CIContext(options: nil)
        let brightnessFilter = CIFilter(name: "CIColorControls")
        brightnessFilter!.setValue(aCIImage, forKey: "inputImage")
        
        brightnessFilter!.setValue(sliderValue, forKey: "inputBrightness")
        let outputImage = brightnessFilter?.outputImage!
        let cgimg = context.createCGImage(outputImage!, from: outputImage!.extent)
        let newUIImage = UIImage(cgImage: cgimg!)
        imgView.image = newUIImage
        print("brightness")
    }
    
    func imageContrast(imgView : UIImageView , sliderValue : CGFloat, image: UIImage){
        
//        guard let aUIImage = image else {
//            return
//        }
//
//        let aCGImage = aUIImage.cgImage
        
        guard let aCGImage = image.cgImage else {
            return
        }
        
        let aCIImage = CIImage(cgImage: aCGImage)
        let context = CIContext(options: nil)
        let contrastFilter = CIFilter(name: "CIColorControls")
        contrastFilter!.setValue(aCIImage, forKey: "inputImage")
        contrastFilter!.setValue(sliderValue, forKey: "inputContrast")
        let outputImage = contrastFilter?.outputImage!
        let cgimg = context.createCGImage(outputImage!, from: outputImage!.extent)
        let newUIImage = UIImage(cgImage: cgimg!)
        imgView.image = newUIImage
        print("contrast")
        
    }
}

extension ViewController {
    
    // MARK: - Save image to photo library
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    
        if let error = error {
            print(error.localizedDescription)
            
            showAlert(withMessage: "Your image hasn't been saved!\n\(error.localizedDescription)!", title: "ERROR")
        }
        
        showAlert(withMessage: "Your image has been saved!", title: "Saved")
    
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
    
    // MARK: - Show image to View
    func showImage(with image: UIImage?) {
        
        guard let image = image else { return }
        self.imageView.image = self.image
        
        invertSlidersVisibility()
        
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
