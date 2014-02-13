class AddKidController < UIViewController
	attr_accessor :user

	def initWithUser(user)
		initWithNibName(nil, bundle:nil)
		self.user = user
		user = @user
		self
	end 

	def viewDidLoad
		super

		self.title = "Select Kids"
		self.navigationController.navigationBarHidden = false
		#self.navigationItem.hidesBackButton = true
		#self.view.backgroundColor = UIColor.whiteColor

		#UINavigationController.setNavigationBarHidden(nil, animated: nil)

		#@leftSaveButton = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
		#	UIBarButtonSystemItemSave,
		#	target: self,
		#	action: 'chekin')
		#self.navigationItem.leftBarButtonItem = @leftSaveButton

		@rightAddButon = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
			UIBarButtonSystemItemAdd,
			target: self,
			action: 'kid_setup')
		self.navigationItem.rightBarButtonItem = @rightAddButon

    	#@data = { "Selected Kids" => @list }
    	@list ||= []

    	#@images ||= []
        #@choices = ["UGBC", "First Christian", "Kernersville Weslyan"]
        #@choices_count = @choices.count
      	screen_layout
      	@selected_kids = []
      	
      	kid_table
      	save_button

	end

	def kid_setup
		controller = KidSetupController.alloc.init
		controller.store_user_id(@user)
		self.presentViewController(
			UINavigationController.alloc.initWithRootViewController(controller),
			animated: true,
			completion: lambda{})
	end

	def screen_layout
		BW::HTTP.get("http://localhost:3000/users/#{@user}/children.json") do |response|
			  	if response.ok?
				  	json = BW::JSON.parse response.body.to_str
				  	json.each do |item|
				  		if item["user_id"] == @user
				  			f = item["first_name"]
				  			l = item["last_name"]

				  			append_list("#{f}""\n""#{l}")

				  		else
				  		  next
				  		end			  		
				  	end
				else
					warn "NOT GOOD!!!"
				end	
			end	

	    
	end

	def append_list(list)
		@list << list
		#p @list
		@table.reloadData
	end

	#def selected_kids
    #  @selected_kids = NSMutableArray.alloc.initWithObjects(nil)
    #  @selected_kids.removeAllObjects
    #  p @selected_kids
  	#end


	#def append_picture(picture)
	#	@picture << picture
	#	p @picture
		#view.reloadData
	#end

	def chekin
		@selected_kids.each do |kid|
			SelectedKids.create(:name => kid)
		end
		
		confirmation = ConfirmationController.alloc.initWithNibName(nil, bundle:nil)
        self.navigationController.pushViewController(confirmation, animated: true)
	end

	def kid_table
		@table = UITableView.alloc.initWithFrame([[0, 0], [self.view.frame.size.width, self.view.frame.size.height]])
		self.view.addSubview(@table)

		@table.delegate = self
		@table.dataSource = self
	end

	def save_button
		#TOOL BAR
	    screen = UIScreen.mainScreen.bounds.size

	    @bottombar = UIToolbar.alloc.initWithFrame(CGRectZero)
	    @bottombar.barStyle = UIBarStyleBlackTranslucent
	    @bottombar.frame = CGRectMake(0, screen.height - 114, screen.width, 50)
	      toolbar_img = UIImage.imageNamed("save_background")
	    @bottombar.setBackgroundImage(toolbar_img, forToolbarPosition: UIToolbarPositionAny, barMetrics: UIBarMetricsDefault)

	    items = NSMutableArray.alloc.init

	    #Settings
	    #save_img = UIImage.imageNamed("save_button")
	    @save_kids = UIButton.buttonWithType(UIButtonTypeCustom)
	    @save_kids.setImage(UIImage.imageNamed('save_button'), forState:UIControlStateNormal)
	    @save_kids.setImage(UIImage.imageNamed('save_button'), forState:UIControlStateHighlighted)
	    @save_kids.addTarget(self, action: "chekin", forControlEvents: UIControlEventTouchUpInside)
	    @save_kids.frame = CGRectMake(0, 0, 320, 56)

	    @barView = UIBarButtonItem.alloc.initWithCustomView(@save_kids)
	    items.addObject(@barView)

	    @bottombar.setItems(items, animated: true)
	    view.addSubview(@bottombar)
	end

 	def tableView(tableView, cellForRowAtIndexPath: indexPath)
    	@reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin     
       UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end

	    #@picker = UIPickerView.alloc.initWithFrame([[0,0],[0,0]])
	    #[self.view.frame.size.width, self.view.frame.size.height]])
	    #self.view.frame.size.height / 2 + 50
		#@picker.delegate = self
		#@picker.showsSelectionIndicator = true

		#@picker_field = UITextField.alloc.initWithFrame([[0,0],[150,40]])
		#@picker_field.textAlignment = NSTextAlignmentCenter
		#@picker_field.placeholder = "Choose Location.."
		#@picker_field.delegate = self
		#@picker_field.inputView = @picker

		cell.textLabel.text = @list[indexPath.row]
		#cell.accessoryView = @picker_field
		cell.selectionStyle = UITableViewCellSelectionStyleNone



	    cell.textLabel.font = UIFont.fontWithName("Helvetica", size:16) #District Pro

    	cell
	end


	def tableView(tableView, numberOfRowsInSection: section)
	#@picture.count
	@list.count
	#@data.count
	end 

	def tableView(tableView, indexPathsForSelectedRows: indexPath)
		self.allowsMultipleSelection = true
	end

	def tableView(tableView, didSelectRowAtIndexPath: indexPath)
	  if tableView.cellForRowAtIndexPath(indexPath).accessoryType == UITableViewCellAccessoryCheckmark
	    tableView.cellForRowAtIndexPath(indexPath).accessoryType = UITableViewCellAccessoryNone
	    @selected_kids.delete(tableView.cellForRowAtIndexPath(indexPath).text)
	    p @selected_kids
	  else
	  	tableView.cellForRowAtIndexPath(indexPath).accessoryType = UITableViewCellAccessoryCheckmark
	    @selected_kids << tableView.cellForRowAtIndexPath(indexPath).text
	    p @selected_kids	
	  end
	end

	def tableView(tableView, heightForRowAtIndexPath: indexPath)
		100
	end

	#def pickerView(pickerView, numberOfRowsInComponent: component)
	#	@choices_count
	#end

	#def pickerView(pickerView, titleForRow: row, forComponent: component)
	#	@choices[row]
	#end

	#def pickerView(pickerView, didSelectRow: row, inComponent: component)
	#		if @picker_field = firstResponder
	#		  @picker_field.text = @choices[row]
	#		  @picker_field.resignFirstResponder
	#		end
	#end


end