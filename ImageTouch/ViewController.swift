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
    @IBOutlet weak var sliderBrightnessValueLabel: UILabel!
    
    @IBOutlet weak var contrastSlider: UISlider!
    @IBOutlet weak var contrastLabel: UILabel!
    @IBOutlet weak var sliderContrastValueLabel: UILabel!
    
    let imageString = "https://www.talkwalker.com/images/2020/blog-headers/image-analysis.png"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSliders()
    }

    @IBAction func contrastSliderMoved(_ sender: UISlider) {
        
        imageContrast(imgView: imageView, sliderValue: CGFloat(sender.value), image: image!)
        let convertedValue = Int(sender.value * 100)
        sliderContrastValueLabel.text = ""
        sliderContrastValueLabel.text = String(format: "%2d", convertedValue)
    }
    
    @IBAction func brightnessSliderMoved(_ sender: UISlider) {
        
        imageBrightness(imgView: imageView, sliderValue: CGFloat(sender.value), image: image!)
        let convertedValue = Int(sender.value * 100)
        sliderBrightnessValueLabel.text = ""
        sliderBrightnessValueLabel.text = String(format: "%2d", convertedValue)
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
    
    
    // MARK: - Invert visibility of labels
    private func invertSlidersVisibility() {
        brightnessLabel.isHidden = !brightnessLabel.isHidden
        brightnessSlider.isHidden = !brightnessSlider.isHidden
        sliderBrightnessValueLabel.isHidden = !sliderBrightnessValueLabel.isHidden
        contrastLabel.isHidden = !contrastLabel.isHidden
        contrastSlider.isHidden = !contrastSlider.isHidden
        sliderContrastValueLabel.isHidden = !sliderContrastValueLabel.isHidden
    }
    
    // MARK: - Set sliders init values
    private func setSliders() {
        invertSlidersVisibility()

        sliderBrightnessValueLabel.text = String(format: "%2d", brightnessSlider.value)

        sliderContrastValueLabel.text = String(format: "%2d", (contrastSlider.value * 100))
    }
    
    // MARK: - Func Logic for Brightness
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
    
    // MARK: - Func Logic for Contrast
    func imageContrast(imgView : UIImageView , sliderValue : CGFloat, image: UIImage){
        
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

// MARK: - Image processing
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
}


extension ViewController {
    
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
