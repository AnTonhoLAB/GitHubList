//
//  UIImage+RX.swift
//  GitHubList
//
//  Created by George Gomes on 01/07/23.
//

import Foundation
import RxSwift

extension Reactive where Base: UIImageView {

    var imageData: Binder<Data> {
        return Binder(self.base) { view, data in
            view.image = UIImage(data: data)
        }
    }
}
