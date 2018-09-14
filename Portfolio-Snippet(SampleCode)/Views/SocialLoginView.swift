
import UIKit

class SocialLoginView: UIView {
    
    enum SocialType {
        case line, kakao, facebook
    }
    
    var type: SocialType? {
        didSet {
            guard type = type else { return }
            setViewLayouts(type)
        }
    }
    
    @IBOutlet private weak var contentView: UIView! {
        didSet {
            contentView.clipsToBounds = true
            contentView.layer.borderWidth = 0
            contentView.layer.cornerRadius = 10
            contentView.backgroundColor = UIColor.white
        }
    }
    
    @IBOutlet private weak var imgView: UIImageView! {
        didSet {
            imgView.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            titleLabel.textAlignment = .center
        }
    }
    
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.setTitle("", for: .normal)
        }
    }
    
    @IBOutlet private weak var verticalView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SocialLoginView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = UIColor.clear
    }
    
    func setViewLayouts(_ type: SocialType) {
        switch type {
        case .line:
            imgView.image = UIImage(named: "line.png")
            contentView.backgroundColor = UIColor.lineGreenColor
            titleLabel.text = SocialLoginTitles.line.rawValue
            titleLabel.textColor = UIColor.white
            verticalView.backgroundColor = UIColor.white
        case .kakao:
            imgView.image = UIImage(named: "kakao.png")
            contentView.backgroundColor = UIColor.kakaoYelllowColor
            titleLabel.text = SocialLoginTitles.kakao.rawValue
            titleLabel.textColor = UIColor.kakaoBrownColor
            verticalView.backgroundColor = UIColor.kakaoBrownColor
        case .facebook:
            imgView.image = UIImage(named: "facebook.png")
            contentView.backgroundColor = UIColor.facebookBlueColor
            titleLabel.text = SocialLoginTitles.facebook.rawValue
            titleLabel.textColor = UIColor.white
            verticalView.backgroundColor = UIColor.white
        }
    }
}

