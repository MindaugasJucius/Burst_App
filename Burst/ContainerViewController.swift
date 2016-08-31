//
//  ContainerViewController.swift
//  Burst
//
//  Created by Mindaugas Jucius on 22/08/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    private var contentViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "BURST"
        navigationController?.navigationBar.translucent = false
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //settingsStoreGetPreferredVC
        let controller = PhotosController(nibName: "PhotosCollectionViewController", bundle: nil)
        contentViewController = controller
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.view.frame = view.bounds
        controller.didMoveToParentViewController(self)
        navigationController?.viewControllers = [controller]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
