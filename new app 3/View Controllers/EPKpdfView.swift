//
//  EPKpdfView.swift
//  new app 3
//
//  Created by William Hinson on 3/31/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit
import PDFKit

class EPKpdfView: UIViewController {
    
    var document: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        
        let pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pdfView)

        pdfView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        guard let url = URL(string: document!) else { return }
        
        if let doc = PDFDocument(url: url) {
            pdfView.document = doc
        }
    }
    
    func configureNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancle))
        navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func handleCancle() {
        dismiss(animated: true, completion: nil)
    }
}
