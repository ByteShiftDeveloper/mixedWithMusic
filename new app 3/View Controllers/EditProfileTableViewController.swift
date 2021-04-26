//
//  EditProfileTableViewController.swift
//  new app 3
//
//  Created by William Hinson on 9/11/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase
import RSKImageCropper
import MobileCoreServices


private let reuseIdentifier = "EditProfileCell"
private let cell2 = "ADMPCell"
private let cell3 = "UserGenreCell"
private let cell4 = "UserLocationCell"
private let cell5 = "ConnectSocialsTVC"
private let cell6 = "AddEPKCell"
private let cell7 = "CurrentEPKCell"


enum PickerType {
    case Artist
    case City
    case State
}

protocol EditProfileControllerDelegate: class {
    func controller(_ controller: EditProfileTableViewController, wantsToUpdate user: User)
//    func handleLogout()
}


class EditProfileTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIDocumentPickerDelegate {
    
    
    let you = ["Artist", "Band", "DJ", "Musician", "Producer"]
    
    var imagePicked = 0
    var imagePicker = UIImagePickerController()
    
   
    var picker:UIPickerView!
    var states : [String] = []
    var cities : [String] = []
    var stateCitesDic : [String:Any] = [:]
    var selectedState : String = "State"
    var selectedLocation: String = ""
    var pickerType : PickerType  = .Artist
    var userLocation = UserLocationCell()
    private var userInfoChanged = false
    weak var delegate: EditProfileControllerDelegate?
    var pdfName: String? = ""
    var pdfURL : URL?
    
    private var actionSheetLauncher: SocialsActionSheetLauncher!


    private var profilemageChanged: Bool {
//        return selectedImage != nil
        return headerView.profileImageView.image != nil
    }
    
    
    private var headerImageChanged: Bool {
//        return selectedImage != nil
        return headerView.containerView.image != nil
    }
    
//    private var selectedImage: UIImage? {
//        didSet{
//
////            headerView.profileImageView.image = selectedImage
//            if imagePicked == 1 {
//            headerView.profileImageView.image = selectedImage
//
//            } else if imagePicked == 2 {
//            headerView.containerView.image = selectedImage
//
//            }
//        }
//
//    }
    
    private var selectedProfileImg : UIImage?
    private var selectedCoverImg : UIImage?

    
    override func viewWillAppear(_ animated: Bool) {
        let cell = tableView.cellForRow(at: [3,0]) as! UserLocationCell
        
        if EditUserLocationTV.location != "" {
            cell.locationName.text = EditUserLocationTV.location
            cell.locationName.textColor = .black
        } else {
            cell.locationName.text = ""
            cell.locationName.textColor = .black
        }
    }

    
    let user: User
    private lazy var headerView = EditProfileHeader(user: user)

    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func  showActionSheet(forUser user: User) {
//        actionSheetLauncher = SocialsActionSheetLauncher(user: user)
//        actionSheetLauncher.delegate = self
//        actionSheetLauncher.show()
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
        headerView.delegate = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
//        selectedState = user.state
        
        
        updateUserdata()
        
        if let path = Bundle.main.path(forResource: "usstatecity", ofType: "json"){
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: [])
                print("json result\(jsonResult)")
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>
                   {
                    stateCitesDic = jsonResult
                    states = Array(stateCitesDic.keys)
                    states.sort()
                    }
                  } catch {
                       // handle error
                    
                  }
            
        }
        
    }
    
    func configureNavBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.title = "Edit Profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancle))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
//        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func handleCancle() {
        dismiss(animated: true, completion: nil)
    }
    
    func updateUserdata() {
        if profilemageChanged && !headerImageChanged {
        updateProfileImage()
        }
        
        if headerImageChanged && !profilemageChanged {
            updateHeaderImage()
        }
        
        if profilemageChanged && headerImageChanged {
            updateProfileImage()
            updateHeaderImage()
        }
        
        if userInfoChanged && !profilemageChanged && !headerImageChanged {
            savePicker()
           
        }
        
        updateEPK()
        
    }
    
    func updateProfileImage() {
        guard let image = selectedProfileImg else { return }
        Service.shared.updateProfileImage(image: image) { profileImageUrl in
            self.user.profileImageURL = profileImageUrl?.absoluteString
            self.delegate?.controller(self, wantsToUpdate: self.user)
            NotificationCenter.default.post(name: NSNotification.Name("UserChanges"), object: nil, userInfo: ["user": self.user])
            print("SUCCESSFULLY UPLOADED DATA")
            }
        
    }
    
    func updateHeaderImage() {
        guard let image = selectedCoverImg else { return }
        Service.shared.updateHeaderImage(image: image) { headerImageUrl in
            self.user.headerImageURL = headerImageUrl?.absoluteString
            self.delegate?.controller(self, wantsToUpdate: self.user)
            NotificationCenter.default.post(name: NSNotification.Name("UserChanges"), object: nil, userInfo: ["user": self.user])
            print("SUCCESSFULLY UPLOADED DATA")
            }
        
    }
    
    func updateEPK() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if pdfURL != nil {
            let storage = Storage.storage()

            let storageRef = storage.reference()

            let localFile = pdfURL

            let riversRef = storageRef.child("EPKs/\(user.fullname  + " EPK.pdf")")

            riversRef.putFile(from: localFile!, metadata: nil) { metadata, error in
                  guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                  }
                  // Metadata contains file metadata such as size, content-type.
                  let size = metadata.size
                  // You can also access to download URL after upload.
                riversRef.downloadURL { url, error in
                  if let error = error {
                    // Handle any errors
                  } else {
                    // Get the download URL for 'images/stars.jpg'
                    guard let epkURL = url else { return }
                    let values = ["EPKpdf": epkURL.absoluteString] as [String:Any]
                    REF_USERS.child(uid).updateChildValues(values)

                    print("URL IS \(String(describing: epkURL))")
                  }
                   
                }
            }
            
        } else {
            print("Did not select a file.")
        }
    }
    
    func savePicker() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let cell = ADMPCell()
        
        let selectedValue = cell.ADMPLabel.text
        
        let ref = Database.database().reference().root
        
        
        let userObject = [
            "What do you consider yourself?":user.artistBand]
        ref.child("users").child(uid).updateChildValues(userObject as [AnyHashable : Any])
    }
    
    func updateGenreStateCity() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().root
        
         let selectedLoc = selectedLocation
        
        
        let userObject = [
            "genre":user.genre, "location": selectedLoc]
        ref.child("users").child(uid).updateChildValues(userObject as [AnyHashable : Any])
    }
    
//    let logoutButton: UIButton = {
//       let button = UIButton()
//        button.setTitle("Logout", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
//        return button
//    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.blackColor
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(handleAccountDeletion), for: .touchUpInside)
        return button
        }()
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let nav = UINavigationController(rootViewController: ViewController())
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    @objc func handleAccountDeletion() {
        print("Deleting Account")
    }

    
    @objc func handleDone() {
        guard profilemageChanged || headerImageChanged else { return }
        updateUserdata()
        updateGenreStateCity()
        savePicker()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        let footerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: self.tableView.frame.width,
                                              height: 70))
        footerView.addSubview(logoutButton)
        logoutButton.centerX(inView: footerView)
        logoutButton.centerY(inView: footerView)
        logoutButton.anchor(width: 300, height: 50)
        logoutButton.setGradientBackground(colorOne: Colors.space, colorTwo: .black)
        self.tableView.tableFooterView = footerView
//        footView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(ADMPCell.self, forCellReuseIdentifier: cell2)
        tableView.register(UserGenreCell.self, forCellReuseIdentifier: cell3)
        tableView.register(UserLocationCell.self, forCellReuseIdentifier: cell4)
        tableView.register(ConnectSocialsTVC.self, forCellReuseIdentifier: cell5)
        tableView.register(AddEPKCell.self, forCellReuseIdentifier: cell6)
//        tableView.register(CurrentEPKCell.self, forCellReuseIdentifier: cell7)
    }
}

extension EditProfileTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
        return EditProfileOptions.allCases.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EditProfileCell
        
        cell.delegate = self
        
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return cell }
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        
        return cell
        } else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: cell3, for: indexPath) as! UserGenreCell
    //        cell.backgroundColor = .black
            cell.user = user
            cell.delegate = self
            cell.selectionStyle = .none
            return cell

        }  else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cell5, for: indexPath) as! ConnectSocialsTVC
            cell.selectionStyle = .none
            return cell
        }  else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cell6, for: indexPath) as! AddEPKCell
            cell.selectionStyle = .none
            if pdfName != "" {
                cell.pdfLabel.text = pdfName
                cell.chevron.tintColor = .darkGray
    
            } else {
                cell.pdfLabel.text = ""
                cell.chevron.tintColor = .clear
            }
            cell.delegate = self
            return cell
        } else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: cell2, for: indexPath) as! ADMPCell
            cell.selectionStyle = .none
            cell.pickerType = .Artist
            cell.user = user
            cell.delegate = self
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cell4, for: indexPath) as! UserLocationCell
            if EditUserLocationTV.location != "" {
                cell.locationName.text = EditUserLocationTV.location
                cell.locationName.textColor = .black
            } else {
                cell.locationName.text = ""
                cell.locationName.textColor = .black
            }
            cell.selectionStyle = .none
            cell.user = user
            cell.delegate = self
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let controller = EditUserLocationTV()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
            if user.location != ""{
                EditUserLocationTV.location = user.location
            }
            controller.didSelectLocation = { [self] selectedLocation in
                if let location = selectedLocation {
                    self.selectedLocation = location
//                    let cell = tableView.cellForRow(at: [3,0]) as! UserLocationCell
//                    cell.user = self.user
//                    cell.configureUI()
                }
            }

        } else if indexPath.section == 4 {
            let nav = UINavigationController(rootViewController: ConnectSocialCollectionView(user: user))
            nav.modalPresentationStyle = .popover
            self.present(nav, animated: true, completion: nil)
            
        }
    }
    
    func uploadEPKPDF(action: UIAlertAction) {
        print("Attemtping to present upload")
        let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
            documentPickerController.delegate = self
            self.present(documentPickerController, animated: true, completion: nil)
    }
    
    func uploadEPKURL(action: UIAlertAction) {
        print("Attemtping to present upload")
        let alertController = UIAlertController(title: "Upload EPK URL", message: "", preferredStyle: .alert)
        

        // Add a textField to your controller, with a placeholder value & secure entry enabled
        alertController.addTextField { textField in
            textField.placeholder = "Enter URL"
            textField.textAlignment = .center
        }

        // A cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Canelled")
        }

        // This action handles your confirmation action
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let epkURL = alertController.textFields?.first?.text else { return }
   
            let values = ["EPK": epkURL ] as [String:Any]

            let ref = REF_USERS.child(uid)
            ref.updateChildValues(values) { (err, ref) in
        }
            print("Current url value: \(alertController.textFields?.first?.text ?? "None")")
        }

        // Add the actions, the order here does not matter
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)

        // Present to user
        present(alertController, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        pdfURL = urls.first
        pdfName = pdfURL?.lastPathComponent
        print("This is the ducoument name \(String(describing: pdfURL))")
        print("this is the pdf name \(String(describing: pdfName))")
        tableView.reloadData()
    }
}

extension EditProfileTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return 0}
        
        return option == .bio ? 100 : 48
        } else if indexPath.section == 5 {
            return 75
        }
        
        return 48
    }
}

extension EditProfileTableViewController {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerType == .City{
            cities = stateCitesDic[selectedState] as? [String] ?? []
            return cities.count
            
        }else if pickerType == .State{
            return states.count
        }else{
          return  you.count

        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerType == .City{
            return cities[row]
        }else if pickerType == .State{
            return states[row]
        }else{
            return you[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let cell = ADMPCell()
//        cell.ADMPLabel.text = you[row]

//        print("you successfully selected \(you[row])")
        
            user.artistBand = you[row]
            
            let cell = tableView.cellForRow(at: [1,0]) as! ADMPCell
            cell.user = user
            cell.configureUI()

        

    }
    
    func handleEPK() {
        let ac = UIAlertController(title: "Please upload your EPK as a URL or PDF document!", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Upload as URL", style: .default, handler: uploadEPKURL))
        ac.addAction(UIAlertAction(title: "Upload as PDF", style: .default, handler: uploadEPKPDF))
          ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.view.tintColor = .black
          ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
          present(ac, animated: true)
    }
    
   
    func editButtonTapped() {
    let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 150, height: 150)
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        picker.delegate = self
        picker.dataSource = self
        
        let row = you.firstIndex(of: user.artistBand) ?? 0
        picker.selectRow(row, inComponent: 0, animated: true)

        vc.view.addSubview(picker)
        let editBandDJAlert = UIAlertController(title: "What do you consider yourself?", message: nil, preferredStyle: UIAlertController.Style.alert)
        editBandDJAlert.setValue(vc, forKey: "contentViewController")
        editBandDJAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        editBandDJAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editBandDJAlert, animated:true)
        tableView.reloadData()

    }
}


extension EditProfileTableViewController: EditProfileDelegate {
    

    func chooseImage1(_ header: EditProfileHeader) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            imagePicked = headerView.profilePicSelect.tag
        present(imagePicker, animated: true)
        }
    }
    
    func chooseImage2(_ header: EditProfileHeader) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            imagePicked = headerView.headerPicSelect.tag
        present(imagePicker, animated: true)
        }
    }
}

extension EditProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        //        let pickedImage2 = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        guard let image = pickedImage else { return }

        imagePicker.dismiss(animated: false, completion: { () -> Void in

               var imageCropVC : RSKImageCropViewController!

            if self.imagePicked == self.headerView.profilePicSelect.tag{
                imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)
                

            }else{
                imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.custom)
                
                imageCropVC.dataSource = self

            }

               imageCropVC.delegate = self

               self.navigationController?.pushViewController(imageCropVC, animated: true)

           })
        
        
//        self.selectedImage = image
//
//        dismiss(animated: true, completion: nil)
    }
    
}


extension EditProfileTableViewController: EditProfileCellDelegate {
    func pickerSelect(_ cell: EditProfileCell) {
        print("SUCCESSFULLY TAPPED PICKER")
        
       
    }
    
    func updateUserInfo(_ cell: EditProfileCell) {
        guard let viewModel = cell.viewModel else { return }
        userInfoChanged = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        switch viewModel.option {
        case .fullname:
            guard let fullname = cell.infoTextField.text else { return }
            user.fullname = fullname
        case .username:
            guard let username = cell.infoTextField.text else { return }
            user.username = username

        case .bio:
            user.bio = cell.bioTextView.text
        }
    }
}

extension EditProfileTableViewController: RSKImageCropViewControllerDelegate{
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.navigationController?.popViewController(animated: true)

    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        if imagePicked == 1 {
            headerView.profileImageView.image = croppedImage
            self.selectedProfileImg = croppedImage
        }else{
            headerView.containerView.image = croppedImage
            self.selectedCoverImg = croppedImage

        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
        
    }
    
    
    
    
}

extension EditProfileTableViewController: RSKImageCropViewControllerDataSource{
    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        let aspectRatio = CGSize(width: 16.0, height: 9.0)

        let viewWidth = controller.view.frame.width
        let viewHeight = controller.view.frame.height

        var maskWidth: CGFloat
        if controller.isPortraitInterfaceOrientation() {
            maskWidth = viewWidth
        } else {
            maskWidth = viewHeight
        }

        var maskHeight: CGFloat
        repeat {
            maskHeight = maskWidth * aspectRatio.height / aspectRatio.width
            maskWidth -= 1.0
        } while maskHeight != floor(maskHeight)
        maskWidth += 1.0

        let maskSize = CGSize(width: maskWidth, height: maskHeight)

        let maskRect = CGRect(
            x: (viewWidth - maskSize.width) * 0.5,
            y: (viewHeight - maskSize.height) * 0.5,
            width: maskSize.width,
            height: maskSize.height)

        return maskRect
    }
    
    func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        let rect = controller.maskRect
        let point1 = CGPoint(x: rect.minX, y: rect.maxY)
        let point2 = CGPoint(x: rect.maxX, y: rect.maxY)
        let point3 = CGPoint(x: rect.maxX, y: rect.minY)
        let point4 = CGPoint(x: rect.minX, y: rect.minY)

        let rectangle = UIBezierPath()
        rectangle.move(to: point1)
        rectangle.addLine(to: point2)
        rectangle.addLine(to: point3)
        rectangle.addLine(to: point4)
        rectangle.close()

        return rectangle
    }
    
    func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        if controller.rotationAngle == 0 {
            return controller.maskRect
        } else {
            let maskRect = controller.maskRect
            let rotationAngle = controller.rotationAngle

            var movementRect = CGRect.zero

            movementRect.size.width = maskRect.width * CGFloat(abs(cos(rotationAngle))) + maskRect.height * CGFloat(abs(sin(rotationAngle)))
            movementRect.size.height = maskRect.height * CGFloat(abs(cos(rotationAngle))) + maskRect.width * CGFloat(abs(sin(rotationAngle)))

            movementRect.origin.x = maskRect.minX + (maskRect.width - movementRect.width) * 0.5
            movementRect.origin.y = maskRect.minY + (maskRect.height - movementRect.height) * 0.5

            movementRect.origin.x = floor(movementRect.minX)
            movementRect.origin.y = floor(movementRect.minY)
            movementRect = movementRect.integral

            return movementRect
        }
        
    }
}
extension EditProfileTableViewController: ADMPCellDelegate {
    func pickerSelect(_ cell: ADMPCell) {
        print("Successfully changed this info")
        pickerType = cell.pickerType

        if pickerType == .City && selectedState == ""{
            print("select state first")
        }else{
            self.editButtonTapped()

        }
        
    }
}

extension EditProfileTableViewController: UserGenreCellDelegate {
    func pickerSelect(_ cell: UserGenreCell) {
        print("SELCTING GENRES")
        let controller = YourGenresTableView()
        navigationController?.pushViewController(controller, animated: true)
        if user.genre != "No genre added"{
            controller.selectedGenreArr = user.genre.components(separatedBy: ", ")
        }
        controller.didSelectGenre = { [self] selectedGenre in
            if let genre = selectedGenre{
                self.user.genre = genre.joined(separator: ", ")
                let cell = tableView.cellForRow(at: [2,0]) as! UserGenreCell
                cell.user = self.user
                cell.configureUI()
            }
        }
    }
}

extension EditProfileTableViewController: UserLocationDelegate {
    func locationSelect(_ cell: UserLocationCell) {
        print("tapped")
    }
    
    
}

extension EditProfileTableViewController: SocialsActionSheetLauncherDelegate {
    func didSelect(option: SocialsActionSheetLauncher) {
        print("Showing the launcher")
    }
}

extension EditProfileTableViewController: AddEPKDelegate {
    func handleEPKTap(_ cell: AddEPKCell) {
        let ac = UIAlertController(title: "Please upload your EPK as a URL or PDF document!", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Upload as URL", style: .default, handler: uploadEPKURL))
        ac.addAction(UIAlertAction(title: "Upload as PDF", style: .default, handler: uploadEPKPDF))
          ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.view.tintColor = .black
          ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
          present(ac, animated: true)
    }
}

