//
//  ViewController.swift
//  SeeFood
//
//  Created by Robin He on 10/24/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import SVProgressHUD
import Social
import TwitterKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var topBarImage: UIImageView!
    let key="dHFx7ZplLm9crLFe7TEkLgI5MC17rqYnXakSeevu9xuc"
    let version="2018-10-24"
    let imagePicker = UIImagePickerController()
    var classificationResults :[String]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isHidden=true
        imagePicker.delegate=self
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        cameraButton.isEnabled=false
        SVProgressHUD.show()
        if let image=info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image=image
            imagePicker.dismiss(animated: true, completion: nil)
            let visualRecognition = VisualRecognition(version: version, apiKey: key)
            
            let imageData = image.jpegData(compressionQuality: 0.01)
            let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let imageUrl = fileUrl.appendingPathComponent("image.jpg")
            
            try? imageData?.write(to: imageUrl,options: [])
            
            visualRecognition.classify(imagesFile: imageUrl, url: nil, threshold: nil, owners: nil, classifierIDs: nil, acceptLanguage: nil, headers: nil, failure: nil) { (classifiedImages) in
                let classes=classifiedImages.images.first!.classifiers.first!.classes
                self.classificationResults=[]
                for index in 0..<classes.count{
                    self.classificationResults.append(classes[index].className)
                }
                print(self.classificationResults)
                DispatchQueue.main.sync {
                   self.cameraButton.isEnabled=true
                    SVProgressHUD.dismiss()
                    self.shareButton.isHidden=false
                }
                if self.classificationResults.contains("hotdog"){
                    DispatchQueue.main.sync {
                          self.navigationItem.title="Hotdog!"
                        self.navigationController?.navigationBar.barTintColor=UIColor.green
                        self.navigationController?.navigationBar.isTranslucent=false
                        self.topBarImage.image=UIImage(named: "notHD")
                    }
                  
                }else{
                    DispatchQueue.main.sync {
                        self.navigationItem.title="Not hotdog!"
                        self.navigationController?.navigationBar.barTintColor=UIColor.red
                        self.navigationController?.navigationBar.isTranslucent=false
                        self.topBarImage.image=UIImage(named: "notHD")

                    }
                }
            }
            
        }else{
            print("There was an error picking image")
        }
    }

    @IBAction func cameraTap(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing=true
        present(imagePicker,animated: true,completion: nil)
        
    }
    
    
    @IBAction func shareTap(_ sender: UIButton) {
        let text="My food is \(navigationItem.title!)"
        let image=imageView.image
        let activityViewController = UIActivityViewController(activityItems: [text,image!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView=self.view
        self.present(activityViewController,animated: true,completion: nil)

    }
}

