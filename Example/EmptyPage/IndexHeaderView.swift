//
//  IndexHeaderView.swift
//  EmptyPage_Example
//
//  Created by 林翰 on 2020/6/17.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Stem

class IndexHeaderView: UICollectionReusableView, STNibProtocol, ConfigurableView {

    static func preferredSize(limit size: CGSize, model: String?) -> CGSize {
        return .init(width: size.width, height: 60)
    }

    @IBOutlet private weak var tapView: UIControl!
    @IBOutlet private weak var titleLabel: UILabel!
    let tapEvent = Delegate<Void, Void>()


    override func awakeFromNib() {
        super.awakeFromNib()
        tapView.layer.st.setBorder(color: .darkGray, width: 0.5)
    }

    func config(_ model: String) {
        titleLabel.text = model
    }

    @IBAction func tapAction(_ sender: UIControl) {
        tapEvent.call()
    }


}
