
import UIKit

class ChatViewCell: UITableViewCell {
    
    var data        : ChatModel!  = nil
    var customView  : UIView      =  UIView()
    var bubbleImage : UIImageView = UIImageView()
    var nameLabel   : UILabel     = UILabel(frame: CGRectMake(0, 0, 70, 70))

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle  = UITableViewCellSelectionStyle.None
        self.backgroundColor = UIColor(patternImage: UIImage(named: "main_back.png")!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupData(data : ChatModel) {
        
        self.addSubview(self.bubbleImage)
        
        self.data = data
        
        let type = self.data.type
        
        let width  : CGFloat = self.data.view.frame.size.width
        let height : CGFloat = self.data.view.frame.size.height
        
        
        var x : CGFloat  = type == NSBubbleType.BubbleTypeSomeoneElse ? 0 : UIScreen.mainScreen().bounds.size.width - width - self.data.insets.left - self.data.insets.right
        var y : CGFloat = 0
        
        self.nameLabel.removeFromSuperview()
        self.nameLabel.text            = self.data.name
        self.nameLabel.textAlignment   = NSTextAlignment.Center
        self.nameLabel.backgroundColor = UIColor.clearColor()
        self.nameLabel.textColor       = UIColor.whiteColor()
        self.nameLabel.sizeToFit();
        
        let nameX : CGFloat = type == NSBubbleType.BubbleTypeSomeoneElse ? 2 : UIScreen.mainScreen().bounds.size.width - 72
        let nameY : CGFloat = max(self.data.insets.top + self.data.insets.bottom + self.data.view.frame.size.height, 72) - 70
        self.nameLabel.frame = CGRectMake(nameX, nameY, 70, 70)
        self.addSubview(self.nameLabel)
        
        let delta = self.frame.size.height - (self.data.insets.top + self.data.insets.bottom + self.data.view.frame.size.height)
        if delta > 0 {
            y = delta
        }
        if type == NSBubbleType.BubbleTypeSomeoneElse {
            x += 74
        }
        if type == NSBubbleType.BubbleTypeMine {
            x -= 74
        }
        
        self.customView.removeFromSuperview()
        self.customView = self.data.view
        self.customView.frame = CGRectMake(self.data.insets.left, self.data.insets.top, width, height)
        self.bubbleImage.addSubview(self.customView)

        if type == NSBubbleType.BubbleTypeSomeoneElse {
            self.bubbleImage.image = UIImage(named: "bubbleSomeone.png")?.stretchableImageWithLeftCapWidth(21, topCapHeight: 14)
        } else {
            self.bubbleImage.image = UIImage(named: "bubbleMine.png")?.stretchableImageWithLeftCapWidth(15, topCapHeight: 14)
        }
        self.bubbleImage.frame = CGRectMake(x, y, width + self.data.insets.left + self.data.insets.right, height + self.data.insets.top + self.data.insets.bottom)

        
    }

}
