import UIKit
import SpriteKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    private var roomTextField : UITextField!
    private var nameTextField : UITextField!
    private var submitButton  : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setComponents()
    }
    
    func setComponents() {
        self.title                   = "Home"
        self.view.backgroundColor    = UIColor.whiteColor()
        // RoomID
        roomTextField                = UITextField(frame: CGRectMake(0,0,self.view.frame.size.width,30))
        roomTextField.delegate       = self
        roomTextField.borderStyle    = UITextBorderStyle.RoundedRect
        roomTextField.layer.position = CGPoint(x:self.view.bounds.width / 2, y:self.view.bounds.height / 2)
        roomTextField.returnKeyType  = UIReturnKeyType.Done
        roomTextField.keyboardType   = UIKeyboardType.Default
        roomTextField.placeholder    = "Input Room Name"
        self.view.addSubview(roomTextField)
        // Name
        nameTextField                = UITextField(frame: CGRectMake(0,0,self.view.frame.size.width,30))
        nameTextField.delegate       = self
        nameTextField.borderStyle    = UITextBorderStyle.RoundedRect
        nameTextField.layer.position = CGPoint(x:self.view.bounds.width / 2, y:self.view.bounds.height / 2 - 50)
        nameTextField.returnKeyType  = UIReturnKeyType.Done
        nameTextField.keyboardType   = UIKeyboardType.Default
        nameTextField.placeholder    = "Input Your Name"
        self.view.addSubview(nameTextField)
        // Button
        submitButton                     = UIButton(type: UIButtonType.Custom)
        submitButton.frame               = CGRectMake(0, 0, 150, 40)
        submitButton.layer.masksToBounds = true
        submitButton.backgroundColor     = UIColor.blueColor()
        submitButton.layer.cornerRadius  = 20.0
        submitButton.layer.position      = CGPoint(x:self.view.bounds.width / 2, y:self.view.bounds.height / 2 + 50)
        submitButton.setTitle("Enter", forState: UIControlState.Normal)
        submitButton.setTitleColor(UIColor.whiteColor(),  forState: UIControlState.Normal)
        submitButton.setTitleColor(UIColor.grayColor(),   forState: UIControlState.Disabled)
        submitButton.addTarget(self, action: "doEnter:", forControlEvents: UIControlEvents.TouchUpInside)
        submitButton.enabled = false
        self.view.addSubview(submitButton)

    }
    
    func doEnter(sender: UIButton) {
        let chatViewController      = ChatViewController()
        chatViewController.roomName = self.roomTextField.text!
        chatViewController.userName = self.nameTextField.text!
        self.navigationController?.pushViewController(chatViewController, animated: true)
        
    }
    
    // UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // UITextFieldDelegate
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        submitButton.enabled = !roomTextField.text!.isEmpty && !nameTextField.text!.isEmpty
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
