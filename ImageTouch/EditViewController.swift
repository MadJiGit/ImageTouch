//
//  EditViewController.swift
//  ImageTouch
//
//  Created by Madji on 21.01.21.
//

import UIKit
import Foundation

class EditViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var photoImageView: UIImageView!
    var photoImage: UIImage?
    
    //MARK: Sliders properties
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var brightnessLabel: UILabel!
    @IBOutlet weak var sliderBrightnessValueLabel: UILabel!
    
    @IBOutlet weak var contrastSlider: UISlider!
    @IBOutlet weak var contrastLabel: UILabel!
    @IBOutlet weak var sliderContrastValueLabel: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        photoImageView?.image = photoImage
        
        setSliders()
    }
    
    
    // MARK: - Navigation bar buttons
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        guard let image = photoImageView.image else {
            return
        }
        
        let shareSheet = UIActivityViewController (
            activityItems: [
                image,
            ],
            applicationActivities: nil
        )
        present(shareSheet, animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let imageToSave = photoImageView.image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Contrast slider function
    @IBAction func contrastSliderMoved(_ sender: UISlider) {
        
        imageContrast(imgView: photoImageView, sliderValue: CGFloat(sender.value), image: photoImage!)
        let convertedValue = Int(sender.value * 100)
        sliderContrastValueLabel.text = ""
        sliderContrastValueLabel.text = String(format: "%2d", convertedValue)
    }
    
    //MARK: - Brightness slider function
    @IBAction func brightnessSliderMoved(_ sender: UISlider) {
        
        imageBrightness(imgView: photoImageView, sliderValue: CGFloat(sender.value), image: photoImage!)
        let convertedValue = Int(sender.value * 100)
        sliderBrightnessValueLabel.text = ""
        sliderBrightnessValueLabel.text = String(format: "%2d", convertedValue)
    }
}

// MARK: - Edit image tools
extension EditViewController {
    
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
    
    // MARK: - Brightness logic
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
    
    // MARK: - Contrast logic
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
extension EditViewController {
    
    // MARK: - Save image to photo library
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    
        if let error = error {
            print(error.localizedDescription)
            
            showAlert(withMessage: "Your image hasn't been saved!\n\(error.localizedDescription)!", title: "ERROR")
        }
        
        showAlert(withMessage: "Your image has been saved!", title: "Saved")
    
    }
    

    
    // MARK: - Show image to View
    func showImage(with image: UIImage?) {
        
        guard let image = image else { return }
        self.photoImageView.image = self.photoImage
        
        invertSlidersVisibility()
        
    }
}


extension EditViewController {
    
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
