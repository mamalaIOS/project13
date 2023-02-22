//
//  ViewController.swift
//  project13
//
//  Created by Amel Sbaihi on 2/11/23.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    
    @IBOutlet var intensity: UISlider!
    
    var currentImage : UIImage!
    
    
    var context : CIContext!
   
    var currentFilter : CIFilter!
    
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = "Image filter" 
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPictures))
     
    context = CIContext()
    currentFilter = CIFilter(name: "CISepiaTone")
        

        
        
    }
    
    
    @IBAction func changeFilter(_ sender: Any) {
        
        let ac = UIAlertController(title: "Change Filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler:setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler:setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler:setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler:setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler:setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler:setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler:setFilter))
        ac.addAction(UIAlertAction(title: "cance", style: .cancel))
        present(ac, animated: true)
        
    
        
    }
    
    
    
    @IBAction func save(_ sender: Any) {
        
        guard let image = imageView.image else {return}
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil )
        
        
    }
    
    
    @IBAction func intesityfunc(_ sender: Any) {
        
       applayProcessing()
    }
    
    
    
    
    
    @objc func importPictures() {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
       present(picker, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        // here we are just making sure that we are gettinh back a uiimage from photo Library.
        
        
        dismiss(animated: true )
        currentImage = image
        
    let beginImage = CIImage(image: currentImage)
        
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
         applayProcessing()
    }
    
    func applayProcessing () {
        
        guard let image = currentFilter.outputImage else {return}
        let inputKeys = currentFilter.inputKeys
       

        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
            if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey) }
            if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey) }
            if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }

        
       
        if let cgImage = context.createCGImage(image, from: image.extent) {
          
            let processedImage = UIImage(cgImage: cgImage)
           
            imageView.image = processedImage   }
        }
    
    
    func setFilter(action : UIAlertAction!) {
        
        guard currentImage != nil else {return }
       
        guard let actionTitle = action.title else {return }
       
        
        currentFilter = CIFilter(name: actionTitle)
       
        
        let beginImage = CIImage(image: currentImage)
        
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applayProcessing()
    }
    
    @objc func image(_ image : UIImage, didFinishSavingWithError error : Error? , contextInfo : UnsafeRawPointer) {
        
        if let error = error {
            
            let ac = UIAlertController(title: "error saving  pictures ", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default))
            present(ac, animated: true)
            
        }
        
        else {
            
            let ac = UIAlertController(title: "saved picture", message: "your picture has been saved succssflly to photo libray ", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
        }
        
        
    }
    
}
