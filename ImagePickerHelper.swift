//
//  ImagePickerHelper.swift
//  Momentos
//
//  Created by Bruno Corrêa on 03/05/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import MobileCoreServices

typealias ImagePickerHelperCompletion = ((UIImage?) -> Void)!

class ImagePickerHelper: NSObject {
    
    weak var viewController:UIViewController!
    var completion: ImagePickerHelperCompletion
    
    init(viewController:UIViewController,completion:ImagePickerHelperCompletion) {
        self.viewController = viewController
        self.completion = completion
        
        super.init()
        
        self.showPhotoSourceSelection()
    }
    
    func showPhotoSourceSelection(){
        
        let actionSheet = UIAlertController(title: "Escolha uma nova foto", message: "Você gostaria de abrir a biblioteca de fotos ou a câmera ?", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action) in
            self.showImagePicker(sourceType: .camera)
        }
        
        let photosLibraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action) in
            self.showImagePicker(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photosLibraryAction)
        actionSheet.addAction(cancelAction)
        
        viewController.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func showImagePicker(sourceType:UIImagePickerControllerSourceType){
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.delegate = self
        
        viewController.present(imagePicker, animated: true, completion: nil)
        
    }
}


extension ImagePickerHelper:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        viewController.dismiss(animated: true, completion: nil)
        completion(image)
    }
    
}
 
