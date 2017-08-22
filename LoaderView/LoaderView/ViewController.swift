//
//  ViewController.swift
//  LoaderView
//
//  Created by Sathyanarayanan V on 8/1/17.
//  Copyright © 2017 Sathyanarayanan V. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let loaderView = VSLoaderView()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(loaderView)
        loaderView.frame.size = CGSize(width: 50, height: 50)
        loaderView.center = view.center
        loaderView.startAnimation()
    }


}

