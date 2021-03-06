//
//  AddEditConsoleViewController.swift
//  MyGames
//
//  Created by aluno on 16/05/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit
import Photos
class AddEditConsoleViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfConsole: UITextField!
    @IBOutlet weak var ivConsoleImage: UIImageView!
    @IBOutlet weak var btAddImage: UIButton!
    @IBOutlet weak var btAddEdit: UIButton!
    
    
    var console: Console?
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfConsole.delegate = self
        prepareDataLayout()
        // Do any additional setup after loading the view.
    }
    func prepareDataLayout() {
        if console != nil {
            title = "Editar Plataforma"
            btAddEdit.setTitle("ALTERAR", for: .normal)
            tfConsole.text = console?.name
            
            ivConsoleImage.image = console?.image as? UIImage
            if console?.image != nil {
                   btAddImage.setTitle(nil, for: .normal)
            }
   
        }

    }
    @IBAction func addConsoleImage(_ sender: UIButton) {

            // para adicionar uma imagem da biblioteca
        
            
            let alert = UIAlertController(title: "Selecinar imagem", message: "De onde você quer escolher a imagem?", preferredStyle: .actionSheet)
            
            let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: {(action: UIAlertAction) in
                self.selectPicture(sourceType: .photoLibrary)
            })
            alert.addAction(libraryAction)
            
            let photosAction = UIAlertAction(title: "Album de fotos", style: .default, handler: {(action: UIAlertAction) in
                self.selectPicture(sourceType: .savedPhotosAlbum)
            })
            alert.addAction(photosAction)
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addEditConsole(_ sender: UIButton) {
        
        if console == nil {
            // context está sendo obtida pela extension 'ViewController+CoreData'
            console = Console(context: context)
        }
        console?.name = tfConsole.text

        console?.image = ivConsoleImage.image
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        // Back na navigation
        navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func chooseImageFromLibrary(sourceType: UIImagePickerController.SourceType) {
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.navigationBar.tintColor = UIColor(named: "main")
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        
        if photos == .denied {
            // TODO considetar exibir um dialogo pedindo para o usuario ir em configuracoes
            print(".denied")
            
        } else if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    
                    self.chooseImageFromLibrary(sourceType: sourceType)
                    
                } else {
                    // TODO considetar exibir um dialogo pedindo para o usuario ir em configuracoes
                    print("unauthorized -- TODO message")
                }
            })
        } else if photos == .authorized {
            
            self.chooseImageFromLibrary(sourceType: sourceType)
        }
    }
}
extension AddEditConsoleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // tip. implementando os 2 protocols o evento sera notificando apos user selecionar a imagem
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // ImageView won't update with new image
            // bug fixed: https://stackoverflow.com/questions/42703795/imageview-wont-update-with-new-image
            DispatchQueue.main.async {
                self.ivConsoleImage.image = pickedImage
                self.ivConsoleImage.setNeedsDisplay() // fixed here
                self.btAddImage.setTitle(nil, for: .normal)
                self.btAddImage.setNeedsDisplay()
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
