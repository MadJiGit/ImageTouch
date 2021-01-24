//
//  EditViewController.swift
//  ImageTouch
//
//  Created by Madji on 21.01.21.
//

import UIKit
import Foundation

class EditViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var photoImageView: UIImageView!
    var photoImage: UIImage?
    
    // MARK: Sliders properties
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var brightnessLabel: UILabel!
    @IBOutlet weak var sliderBrightnessValueLabel: UILabel!
    
    @IBOutlet weak var contrastSlider: UISlider!
    @IBOutlet weak var contrastLabel: UILabel!
    @IBOutlet weak var sliderContrastValueLabel: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        photoImageView?.image = photoImage
        setSliders()
    }
    
    
    // MARK: - Cancel navigation bar buttons
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - Share navigation bar button
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
    
    // MARK: - Contrast slider function
    @IBAction func contrastSliderMoved(_ sender: UISlider) {
        
        imageContrast(imgView: photoImageView, sliderValue: CGFloat(sender.value), image: photoImage!)
        let convertedValue = Int(sender.value * 100)
        sliderContrastValueLabel.text = ""
        sliderContrastValueLabel.text = String(format: "%2d", convertedValue)
    }
    
    // MARK: - Brightness slider function
    @IBAction func brightnessSliderMoved(_ sender: UISlider) {
        
        imageBrightness(imgView: photoImageView, sliderValue: CGFloat(sender.value), image: photoImage!)
        let convertedValue = Int(sender.value * 100)
        sliderBrightnessValueLabel.text = ""
        sliderBrightnessValueLabel.text = String(format: "%2d", convertedValue)
    }
}

// MARK: - Edit image tools
extension EditViewController {
    
    // MARK: - Set sliders init values
    private func setSliders() {

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
    }
}


