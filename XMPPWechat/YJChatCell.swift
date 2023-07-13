//
//  YJChatCell.swift
//  XMPPWechat
//
//  Created by Joting You on 2023/7/13.
//  Copyright © 2023 姚家庆. All rights reserved.
//

import UIKit
import SnapKit
class YJMyChatCell: YJChatCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.bubbleView.backgroundColor = UIColor.blue
        self.bubbleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.right.bottom.equalToSuperview().offset(-16)
            make.left.lessThanOrEqualToSuperview().offset(16)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class YJOtherChatCell:YJChatCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.bubbleView.snp.makeConstraints { make in
            make.right.lessThanOrEqualToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
        }
        self.bubbleView.backgroundColor = UIColor.red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
@objc class YJChatCell: UITableViewCell {
    let bubbleView = UIView()
    let titleLabel = UILabel()
    let imgView = UIImageView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(bubbleView)
        bubbleView.addSubview(titleLabel)
        bubbleView.addSubview(imgView)
        bubbleView.layer.cornerRadius = 8
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        imgView.contentScaleFactor = UIScreen.main.scale
        imgView.contentMode = .scaleAspectFit
        imgView.autoresizingMask = .flexibleHeight
        imgView.clipsToBounds = true
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
    @objc func set(title:String? = nil,image:UIImage? = nil){
        titleLabel.text = title
        imgView.image = image
        imgView.isHidden = image == nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc static func reusableIdentifier() -> String {
        return "\(Self.self)"
    }
}
