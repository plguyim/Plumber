import UIKit
import Plumber
import SnapKit

class AnimalCell: UITableViewCell {
    var avatar: UIImageView?
    var nameLabel: UILabel?
    var sender: PlumberSender<Animal>?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        createUI()
        bindEvents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() {
        let avatar = UIImageView(frame: .zero)
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        contentView.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(5)
            make.width.equalTo(180)
            make.height.equalTo(avatar.snp.width).multipliedBy(9.0/16.0)
            make.bottom.equalToSuperview().offset(-5).priority(.medium)
        }
        self.avatar = avatar
        
        let nameLabel = UILabel(frame: .zero)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 1
        nameLabel.textAlignment = .left
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(avatar)
            make.left.equalTo(avatar.snp.right).offset(5)
            make.right.equalTo(contentView).offset(-5)
        }
        self.nameLabel = nameLabel
    }
    
    func bindEvents() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        self.avatar?.addGestureRecognizer(tap)
        self.avatar?.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped() {
        self.sender?.send(AnimalCell.Events.didKittenGrowled)
    }
}

extension AnimalCell: PlumberConfigurable {
    
    enum Events {
        case didKittenGrowled
    }
    
    static var reuseIdentifier: String {
        "AnimalCell"
    }
    
    func configure(sender: PlumberSender<Animal>) {
        self.sender = sender
        
        self.avatar?.image = UIImage(named: sender.data.localImageName)
        self.nameLabel?.text = sender.data.name
    }
    
}
