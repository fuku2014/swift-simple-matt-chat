

import UIKit

enum NSBubbleType {
    case BubbleTypeMine
    case BubbleTypeSomeoneElse
}

let textInsetsMine    : UIEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 11, right: 17)
let textInsetsSomeone : UIEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 11, right: 10)

class ChatModel: NSObject {
    var type   : NSBubbleType
    var view   : UIView
    var insets : UIEdgeInsets
    var name   : String
    
    init(view : UIView, type : NSBubbleType, insets : UIEdgeInsets, name : String) {
        self.view   = view
        self.type   = type
        self.insets = insets
        self.name   = name
        super.init()
    }
    
    convenience init(text : String, type : NSBubbleType, name : String) {
        let font     : UIFont   = UIFont.systemFontOfSize(UIFont.systemFontSize())
        let size     : CGSize   =  CGSizeMake(220, 9999)
        let label    : UILabel  = UILabel(frame: CGRectMake(0, 0, size.width, size.height))
        
        label.numberOfLines   = 0
        label.lineBreakMode   = NSLineBreakMode.ByWordWrapping
        label.text            = text
        label.font            = font
        label.backgroundColor = UIColor.clearColor()
        label.sizeToFit()
        
        let insets : UIEdgeInsets = (type == NSBubbleType.BubbleTypeMine ? textInsetsMine : textInsetsSomeone)
        self.init(view: label, type: type, insets: insets, name: name)
    }
}

