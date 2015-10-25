import UIKit
import SpriteKit
import Moscapsule

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var roomName : String = ""
    var userName : String = ""
    
    var itemes         : [ChatModel] = []
    var chatTableView  : UITableView!
    var chatInputBar   : UIToolbar!
    var submitButton   : UIButton!
    var inputTextField : UITextField!
    
    var mqttConfig   : MQTTConfig!
    var mqttClient   : MQTTClient!
    
    let uuid = NSUUID().UUIDString


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setComponents()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let const = Const()
        
        mqttConfig = MQTTConfig(clientId: uuid, host: const.MQTT_HOST, port: const.MQTT_PORT, keepAlive: 60)
        mqttConfig.mqttAuthOpts = MQTTAuthOpts(username: const.MQTT_USER, password: const.MQTT_PW)
        mqttConfig.cleanSession = true
    
        mqttConfig.onMessageCallback = { mqttMessage in
            let msg  : String   = mqttMessage.payloadString!
            let data : [String] = msg.characters.split(",").map{ String($0) }
            dispatch_async(dispatch_get_main_queue(), {
                self.showMessage(data)
            })
        }
        
        mqttClient = MQTT.newConnection(mqttConfig)
        
        mqttClient.subscribe(roomName, qos: 2)
        
    }
    
    func showMessage(data : [String]) {
        let subscribeUUID     : String = data[0]
        let subscribeUserName : String = data[1]
        var subscribeMessage  : String = ""
        
        for i in 2...data.count - 1 {
            subscribeMessage += data[i]
        }
        
        let type = subscribeUUID == uuid ? NSBubbleType.BubbleTypeMine : NSBubbleType.BubbleTypeSomeoneElse
        self.itemes.append(ChatModel(text: subscribeMessage, type: type, name: subscribeUserName))
        self.chatTableView.reloadData()
        
        let nos = chatTableView.numberOfSections
        let nor = chatTableView.numberOfRowsInSection(nos - 1)
        let lastPath:NSIndexPath = NSIndexPath(forRow:nor - 1, inSection:nos - 1)
        chatTableView.scrollToRowAtIndexPath( lastPath , atScrollPosition: .Bottom, animated: true)
    }
    
    func setComponents() {
        self.title = roomName
        
        chatTableView  = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 40),
                                     style: UITableViewStyle.Plain)
        chatInputBar   = UIToolbar(frame: CGRectMake(0, self.view.frame.height - 40, self.view.frame.width, 40))
        submitButton   = UIButton(type: UIButtonType.Custom)
        inputTextField = UITextField(frame: CGRectMake(0, 0, self.view.frame.width - 60, 40))
        
        // chatTableView
        chatTableView.backgroundColor                = UIColor(patternImage: UIImage(named: "main_back.png")!)
        chatTableView.separatorStyle                 = UITableViewCellSeparatorStyle.None
        chatTableView.showsVerticalScrollIndicator   = false
        chatTableView.showsHorizontalScrollIndicator = false
        chatTableView.registerClass(ChatViewCell.self, forCellReuseIdentifier: "tblBubbleCell")
        chatTableView.dataSource = self
        chatTableView.delegate   = self
        self.view.addSubview(chatTableView)
        
        // submitButton
        submitButton.frame               = CGRectMake(0, 0, 60, 40)
        submitButton.backgroundColor     = UIColor.blueColor()
        submitButton.enabled = false
        submitButton.setTitle("Send", forState: UIControlState.Normal)
        submitButton.setTitleColor(UIColor.whiteColor(),  forState: UIControlState.Normal)
        submitButton.setTitleColor(UIColor.grayColor(),   forState: UIControlState.Disabled)
        submitButton.addTarget(self, action: "doSubmit:", forControlEvents: UIControlEvents.TouchUpInside)
        submitButton.layer.position = CGPoint(x:self.view.frame.size.width - submitButton.frame.size.width / 2,
                                              y:submitButton.frame.size.height / 2)
        
        // inputTextField
        inputTextField.delegate       = self
        inputTextField.borderStyle    = UITextBorderStyle.RoundedRect
        inputTextField.returnKeyType  = UIReturnKeyType.Done
        inputTextField.keyboardType   = UIKeyboardType.Default
        chatInputBar.barStyle         = UIBarStyle.BlackTranslucent
        chatInputBar.tintColor        = UIColor.whiteColor()
        chatInputBar.backgroundColor  = UIColor.blackColor()
        inputTextField.layer.position = CGPoint(x:self.view.frame.width / 2 - submitButton.frame.size.width / 2 ,
                                                y:inputTextField.frame.size.height / 2);
        
        // chatInputBar
        chatInputBar.addSubview(submitButton)
        chatInputBar.addSubview(inputTextField)
        self.view.addSubview(chatInputBar)
        
        // notificationCenter
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:",
                                             name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:",
                                             name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func doSubmit(sender: UIButton) {
        let msg : String = [uuid, userName, inputTextField.text!].joinWithSeparator(",")
        
        mqttClient.publishString(msg, topic: roomName , qos: 2, retain: false)
        inputTextField.resignFirstResponder()
        inputTextField.text = ""
    }
    
    // handleKeyboardWillShowNotification
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        
        let userInfo               = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let transform  = CGAffineTransformMakeTranslation(0, -keyboardScreenEndFrame.size.height);
        self.view.transform = transform
    }
    
    // handleKeyboardWillShowNotification
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        self.view.transform = CGAffineTransformIdentity
    }
    
    // UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemes.count
    }
    
    // UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "tblBubbleCell"
        let cell : ChatViewCell = tableView.dequeueReusableCellWithIdentifier(cellId) as! ChatViewCell
        let data : ChatModel = self.itemes[indexPath.row]
        cell.setupData(data)
        return cell
    }
    
    // UITableViewDataSource
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let data    : ChatModel = self.itemes[indexPath.row]
        return max(data.insets.top + data.view.frame.size.height + data.insets.bottom, 52)
    }
    
    // UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // UITextFieldDelegate
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        submitButton.enabled = !textField.text!.isEmpty
        return true
    }
    
    override func viewDidDisappear(animated: Bool){
        super.viewDidDisappear(animated)
        mqttClient.unsubscribe(roomName, requestCompletion: nil)
        mqttClient.disconnect()
    }

}
