class KidSetupController < UIViewController
	attr_accessor :add_kid_controller #change back to add_kid_

	def store_user_id(user)
		@id = user
	end

	def viewDidLoad
		super
		self.title = "Add Kids"
		self.view.backgroundColor = UIColor.colorWithRed(0.8706, green:0.8980, blue:0.9294, alpha: 1)

		self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
			UIBarButtonSystemItemCancel,
			target: self,
			action: :cancelAddKid)

		self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
			UIBarButtonSystemItemSave,
			target: self,
			action: 'addkids')

	    #Add Photo
	    @button = UIButton.buttonWithType(UIButtonTypeCustom)
	    @button.setImage(UIImage.imageNamed('add_photo'), forState:UIControlStateNormal)
	    #Add 2nd button Later for effects...
	    #@button.setImage(UIImage.imageNamed('button3'), forState:UIControlStateHighlighted)
		@button.frame = [[110, 5], [100, 100]]
		#@button.center = 
			#[self.view.frame.size.width / 2, self.view.frame.size.height / 1 - 80]

		@button.addTarget(self,
			action: "action",
			forControlEvents:UIControlEventTouchUpInside)

		@table = UITableView.alloc.initWithFrame([[0,0], [320, 640]], 
			style: UITableViewStyleGrouped)
		@table.autoresizingMask = UIViewAutoresizingFlexibleHeight
		@table.backgroundView = nil
		@table.tableHeaderView = @button
	    self.view.addSubview(@table)

	    @table.dataSource = self
	    @table.delegate = self

		loadButtons

	    
	    @data = {
	    	"Personal Information" => ["First Name", "Last Name", "Birthdate"],
	    	"Additional Information" => ["Allergens", "Locations"]}

	end

	def tableView(tableView, numberOfRowsInSection: section)
		@data.count
	end

	def tableView(tableView, cellForRowAtIndexPath: indexPath)
		@reuseIdentifier ||= "CELL_IDENTIFIER"

		cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier)
		cell = UITableViewCell.alloc.initWithStyle(
				UITableViewCellStyleDefault,
				reuseIdentifier: @reuseIdentifier)

		cell.textLabel.font = UIFont.fontWithName("Helvetica", size:16) #District Pro



		@text = UITextField.alloc.initWithFrame([[140, 12], [160, 50]])
		@text.font = UIFont.fontWithName("Helvetica", size:16) #District Pro

		if (indexPath.section) == 0

			if (indexPath.row) == 0
				@kidfirst = @text
				@kidfirst.placeholder = "First Name" 
				@kidfirst.textAlignment = UITextAlignmentRight
				cell.addSubview(@kidfirst)
			elsif (indexPath.row) == 1
				@kidlast = @text
				@kidlast.placeholder = "Last Name"
				@kidlast.textAlignment = UITextAlignmentRight
				cell.addSubview(@kidlast)
			elsif (indexPath.row) == 2
				@kidbdate = @text
				@kidbdate.placeholder = "01-01-2000"
				@kidbdate.textAlignment = UITextAlignmentRight
				cell.addSubview(@kidbdate)
			end
		end

		if (indexPath.section) == 1

			if (indexPath.row) == 0
				@kidallergens #= UIButton.buttonWithType(UIButtonTypeRoundedRect)
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
				cell.addSubview(@kidallergens)
			elsif (indexPath.row) == 1
				@kidlocations #= UIButton.buttonWithType(UIButtonTypeRoundedRect)
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
				cell.addSubview(@kidlocations)
			end
		end

		cell.textLabel.text = row_for_index_path(indexPath)
		cell
	end
					
	def tableView(tableView, didSelectRowAtIndexPath: indexPath)
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		if (indexPath.section) == 1
			if (indexPath.row) == 0
				allergens = AllergensController.alloc.initWithNibName(nil, bundle:nil)
				self.navigationController.pushViewController(allergens, animated: true)
			elsif (indexPath.row) == 1
				locations = LocationsController.alloc.initWithNibName(nil, bundle:nil)
				self.navigationController.pushViewController(locations, animated: true)
			end
		end 

	end

	#Add Photo

	def action
		sheet = UIActionSheet.alloc.initWithTitle("Add Photo",
		  delegate:self,
		  cancelButtonTitle:'Cancel',
		  destructiveButtonTitle:nil,
		  otherButtonTitles:"Open Gallery", "Take A Picture", nil)
		sheet.showInView(view)
	end

	def actionSheet(sheet, didDismissWithButtonIndex:buttonIndex)
	  if (buttonIndex) == 0
	  	open_gallery
	  elsif (buttonIndex) == 1
	  	start_camera
	  end
	end

	def loadButtons
		@image_picker = UIImagePickerController.alloc.init
    	@image_picker.delegate = self
    end

    # Need to fix width and height or picture...
  	def imagePickerController(picker, didFinishPickingImage:image, editingInfo:info)
	    self.dismissModalViewControllerAnimated(true)

	    #@image_pic = UIImagePNGRepresentation(image)
	    	#@image_test = NSData.initWithData(@image_data)
	    #p @image_pic

	    #@image_data = NSData.initWithData

	    @image_view.removeFromSuperview if @image_view
	    @image_view = UIImageView.alloc.initWithImage(image)
	    @image_view.frame = [[123, 14], [75, 82]]
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

	def sections
		@data.keys
	end

	def rows_for_section (section_index)
		@data[self.sections[section_index]]
	end

	def row_for_index_path(index_path)
		rows_for_section(index_path.section)[index_path.row]
	end

	def numberOfSectionsInTableView(tableView)
		self.sections.count
	end

	def tableView(tableView, numberOfRowsInSection: section)
		rows_for_section(section).count
	end

	def tableView(tableView, titleForHeaderInSection: section)
		sections[section]
	end

	#I think this code will work for Cancelling and going back.  Verify with Jason
	def cancelAddKid
		self.dismissViewControllerAnimated(true, completion: lambda {})
	end

	def addkids
		first = @kidfirst.text
		last = @kidlast.text
		photo = nil
		p @id
		data = {child: {first_name: "#{first}", last_name: "#{last}", user_id: "#{@id}", image: "#{photo}"}}

		BW::HTTP.post("http://localhost:3000/users/#{@id}/children.json", {payload: data}) do |response|
		  if response.ok?
		  	p response.body.to_s
				json = BW::JSON.parse response.body.to_str
			  	p json
		    p "Successful"
		  else
		    p "not successful" 
		  end
		end
		child_list = AddKidController.alloc.initWithUser(@id) #change back to AddKid
		self.navigationController.pushViewController(child_list, animated: true)

	end

	#def addkids
		#Need to fix...
	#	first = @kidfirst.text
	#	last = @kidlast.text
	
	#	if first == nil
	#	  prompt = UIAlertView.alloc.initWithTitle("Error",
    #                  message: "Please enter your child's first name.",
    #                  delegate: nil,
    #                  cancelButtonTitle: "Close",
    #                  otherButtonTitles: nil)   
    #  		prompt.show
	#	else
	#	  Child.create(:first_name => "#{first}", :last_name => "#{last}")
	#	  self.dismissViewControllerAnimated(true, completion: lambda {})
    #  	end
	#end
end