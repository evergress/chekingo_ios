class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
  	@window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  	#@window.backgroundColor = UIColor.colorWithPatternImage(UIImage.imageNamed("logo"))

    documents_path         = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0]
	  NanoStore.shared_store = NanoStore.store(:file, documents_path + "/nano.db")
  


    UINavigationBar.appearance.setBackgroundImage(UIImage.imageNamed("navbar"), forBarMetrics: UIBarMetricsDefault)
    navigationBar = UINavigationBar.appearance

    navigationBar.setTitleTextAttributes({
      UITextAttributeFont => UIFont.fontWithName("Helvetica", size:22), #District Pro
      #UITextAttributeTextShadowColor => UIColor.colorWithWhite(0.0, alpha:0.4),
      #UITextAttributeTextColor => UIColor.colorWithRed(0.36863, green:0.58431, blue:0.82353, alpha: 1)
      })

    UIBarButtonItem.appearance.tintColor = UIColor.colorWithRed(0.4196, green:0.6588, blue:0.8980, alpha: 1)

    @user_controller = LogInController.alloc.initWithNibName(nil, bundle:nil)
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(@user_controller)
    
    @window.makeKeyAndVisible

    true
  end

  
end
