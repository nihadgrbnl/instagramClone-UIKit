//
//  BaseController.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 11.03.26.
//

import UIKit

class BaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        configureConstraints()
        configureViewModel()
    }
    
    func configureUI() {}
    
    func configureConstraints() {}
    
    func configureViewModel() {}
}
