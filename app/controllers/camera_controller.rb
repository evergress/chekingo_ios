class CameraController < UIViewController
attr_accessor :add_kid_controller
  def viewDidLoad
    view.backgroundColor = UIColor.whiteColor
    #view.backgroundColor = UIColor.underPageBackgroundColor
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemCancel,
      target: self,
      action: 'back')
    loadButtons
  end

  def back 
    self.dismissViewControllerAnimated(true, completion: lambda {})
  end

  def loadButtons
    @camera_button = UIButton.buttonWithType(UIButtonTypeCustom)
    @camera_button.setImage(UIImage.imageNamed('camera'), forState:UIControlStateNormal)
    @camera_button.frame  = [[20, 70], [64, 64]]
    @camera_button.addTarget(self, action: :start_camera, forControlEvents:UIControlEventTouchUpInside)
    view.addSubview(@camera_button)

    @gallery_button = UIButton.buttonWithType(UIButtonTypeCustom)
    @gallery_button.setImage(UIImage.imageNamed('gallery'), forState:UIControlStateNormal)
    @gallery_button.frame  = [[20, 140], [64, 64]]
    @gallery_button.addTarget(self, action: :open_gallery, forControlEvents:UIControlEventTouchUpInside)
    view.addSubview(@gallery_button)

    @image_picker = UIImagePickerController.alloc.init
    @image_picker.delegate = self 
  end

  #Tells the delegate that the user picked a still image or movie.
  def imagePickerController(picker, didFinishPickingImage:image, editingInfo:info)
    self.dismissModalViewControllerAnimated(true)
    @image_view.removeFromSuperview if @image_view
    @image_view = UIImageView.alloc.initWithImage(image)
    @image_view.frame = [[100, 50], [170, 170]]
    view.addSubview(@image_view)
  end
     
  def start_camera
    if camera_present
      @image_picker.sourceType = UIImagePickerControllerSourceTypeCamera
      presentModalViewController(@image_picker, animated:true)
    else
      show_alert
    end
  end

  def open_gallery
    @image_picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary
    presentModalViewController(@image_picker, animated:true)
  end

  def show_alert
    @alert_box = UIAlertView.alloc.initWithTitle("Error",
      message: "Sorry, Chekingo cannot use your Camera. Please select a picture from your Carmera Roll",
      delegate: nil,
      cancelButtonTitle: "Okay",
      otherButtonTitles: nil)
    @alert_box.show
  end

  #Check Camera available or not
  def camera_present
    UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceTypeCamera)
  end
end