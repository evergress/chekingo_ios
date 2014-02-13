class LinkGuardianController < UIViewController
  def viewDidLoad

  	super
    #self.navigationController.navigationBarHidden = true

    #self.main_layout

   # BubbleWrap::HTTP.post("http://ec2-54-221-236-156.compute-1.amazonaws.com/children", 
   #   payload: {first_name: "Jackson", last_name: "Milam"}) do |response|
   #   p response
   # end

   #selected_kids

    self.title = "Link Guardians"

    #BACKGROUND
    gradient = CAGradientLayer.layer
    gradient.frame = view.bounds
    gradient.colors = [UIColor.colorWithRed(0.7098, green:0.8196, blue:0.9451, alpha: 1).CGColor, UIColor.colorWithRed(0.9255, green:0.9255, blue:0.9255, alpha: 1).CGColor]
    view.layer.addSublayer(gradient)

    #PHONE NUMBER
    @phone = UITextField.alloc.initWithFrame([[10, 40], [300, 55]])
    @phone.borderStyle = UITextBorderStyleRoundedRect
    @phone.keyboardType = UIKeyboardTypePhonePad
    @phone.font = UIFont.fontWithName("Helvetica", size: 23)
    @phone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
    @phone.adjustsFontSizeToFitWidth = true
    @phone.placeholder = "Phone Number: 1234567890"
    @phone.textAlignment = NSTextAlignmentCenter
    self.view.addSubview(@phone)

    @button = UIButton.buttonWithType(UIButtonTypeCustom)
      @button.setImage(UIImage.imageNamed('next-button'), forState:UIControlStateNormal)
      @button.setImage(UIImage.imageNamed('next-button-click'), forState:UIControlStateHighlighted)
    @button.frame = CGRectMake(10, 100, 300, 55)
    self.view.addSubview(@button)

    @button.addTarget(self,
      action: "main_login",
      forControlEvents:UIControlEventTouchUpInside)

    #CREATE ACCOUNT
    #@create_account_label = UILabel.alloc.initWithFrame(CGRectZero)
    #@create_account_label.text = "Create Account"
    #@create_account_label.sizeToFit
    #@create_account_label.backgroundColor = UIColor.clearColor
    #@create_account_label.textColor = UIColor.blueColor
    #@create_account_label.textAlignment = UITextAlignmentCenter
    #@create_account_label.frame = [[50, 200], [220, 50]]

    #self.view.addSubview(@create_account_label)

    #@create_account_label.userInteractionEnabled = true
    #recognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action: 'create_account' )
    #@create_account_label.addGestureRecognizer(recognizer)

    #self.navigationController.setToolbarHidden(true, animated: nil)

    #TOP BAR FOR KEYBOARD
    @numberTopBar = UIToolbar.alloc.initWithFrame(CGRectMake(0, 0, 320, 50))
    @numberTopBar.barStyle = UIBarStyleBlackTranslucent
    @numberTopBar.sizeToFit

    items = NSMutableArray.alloc.init

    @cancel = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemCancel, target: self, action: "cancelPad")
    items.addObject(@cancel)
    
    @flexible = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target: nil, action: nil)
    items.addObject(@flexible)

    @done = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemDone, target: self, action: "main_login")
    items.addObject(@done)

    @numberTopBar.setItems(items, animated: true)

    @phone.inputAccessoryView = @numberTopBar


    #TOOL BAR
    screen = UIScreen.mainScreen.bounds.size

    @bottombar = UIToolbar.alloc.initWithFrame(CGRectZero)
    @bottombar.barStyle = UIBarStyleBlackTranslucent
    @bottombar.frame = CGRectMake(0, screen.height - 125, screen.width, 50)
      toolbar_img = UIImage.imageNamed("bottombar")
    @bottombar.setBackgroundImage(toolbar_img, forToolbarPosition: UIToolbarPositionAny, barMetrics: UIBarMetricsDefault)

    items = NSMutableArray.alloc.init

    #Settings
    settings_img = UIImage.imageNamed("settings")
    @button_settings = UIButton.buttonWithType(UIButtonTypeCustom)
    @button_settings.setImage(settings_img, forState:UIControlStateNormal)
    @button_settings.addTarget(self, action: "create_account", forControlEvents: UIControlEventTouchUpInside)
    @button_settings.frame = CGRectMake(5, 0, 140, 40)

    @barView = UIBarButtonItem.alloc.initWithCustomView(@button_settings)
    items.addObject(@barView)

    #Legal+Info
    legal_img = UIImage.imageNamed("legal")
    @button_info = UIButton.buttonWithType(UIButtonTypeCustom)
    @button_info.setImage(legal_img, forState:UIControlStateNormal)
    @button_info.addTarget(self, action: "settings", forControlEvents: UIControlEventTouchUpInside)
    @button_info.frame = CGRectMake(0, 0, 140, 40)

    @leftbutton = UIBarButtonItem.alloc.initWithCustomView(@button_info)
    items.addObject(@leftbutton)

    @bottombar.setItems(items, animated: true)
    view.addSubview(@bottombar)
    
    #self.navigationController.setToolbarHidden(nil, animated: nil)

   

    end

  
     

    #def selected_kids
    #    @selected_kids = NSMutableArray.alloc.initWithObjects(nil)
    #    @selected_kids.removeAllObjects
        #p @selected_kids
    #end

  def cancelPad
      @phone.resignFirstResponder
  end


end