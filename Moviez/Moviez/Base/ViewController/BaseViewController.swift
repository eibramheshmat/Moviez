//
//  BaseViewController.swift
//  Moviez
//
//  Created by Ibram on 10/3/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import UIKit

class BaseViewController<T: BaseViewModel>: UIViewController {
    
    var viewModel: T!
    
    func supscripLoadingState() {
        viewModel.loading = {(isLoad) in
            DispatchQueue.main.async {
                if isLoad{
                    Loading.shared.show()
                }else{
                    Loading.shared.hide()
                }
            }
        }
    }
    
    /* This method to show alert in all view controllers */
    func showAlert(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
