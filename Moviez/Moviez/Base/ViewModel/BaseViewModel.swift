//
//  BaseViewModel.swift
//  Moviez
//
//  Created by Ibram on 10/4/20.
//  Copyright © 2020 Ibram. All rights reserved.

import Foundation

class BaseViewModel{
    
    var loading: ((_ isShow: Bool) -> ())?  /// to listen about loading at all view controllers
    var getErrorObserver: ((_ error: String)->())? /// to listen about error at all view controllers 
}
