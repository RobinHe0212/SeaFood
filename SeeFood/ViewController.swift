//
//  ViewController.swift
//  SeeFood
//
//  Created by Robin He on 10/24/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import UIKit
import VisualRecognitionV3

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    let key="dHFx7ZplLm9crLFe7TEkLgI5MC17rqYnXakSeevu9xuc"
    let version="2018-10-24"
    let imagePicker = UIImagePickerController()
    var classificationResults :[String]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate=self
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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
                if self.classificationResults.contains("hotdog"){
                    DispatchQueue.main.sync {
                          self.navigationItem.title="Hotdog!"
                    }
                  
                }else{
                    DispatchQueue.main.sync {
                        self.navigationItem.title="Not hotdog!"

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
}

