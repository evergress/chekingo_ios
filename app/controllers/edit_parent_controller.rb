class EditParentController < UIViewController
	def viewDidLoad
		super

		  self.title = "Edit Account"
      self.view.backgroundColor = UIColor.colorWithRed(0.8706, green:0.8980, blue:0.9294, alpha: 1)
    	@scrollwindow = UIScrollView.alloc.initWithFrame(CGRect.new([0,0],[1200,1200]))
    	@scrollwindow.contentSize = CGSize.new(self.view.frame.size.width,1500)
    	@scrollwindow.scrollEnabled = true
    	@scrollwindow.delegate
    	self.view.addSubview(@scrollwindow)

  		@data = {"Profile Information" => ["First Name", "Last Name", "Email", "Password", "Confirm", "Phone #", "Location"]}

      @first ||= []
      parent_layout
      kid_table
      save_button

	end

  def parent_layout
    BW::HTTP.get("http://localhost:3000/users.json") do |response|
          if response.ok?
            json = BW::JSON.parse response.body.to_str
            json.each do |item|
              if item["user_id"] == @user
                f = item["first_name"]
                #l = item["last_name"]
                #e = item["email"]
                #ph = item["phone_number"]


                append_first(f)
                #append_last(l)
                #append_email(e)
                #append_phone(ph)

              else
                next
              end           
            end
        else
          warn "NOT GOOD!!!"
        end 
      end 

      
  end

  def append_first(first)
    @first << first
    #p @list
    @table.reloadData
  end

  def append_last(last)
    @last << last
    #p @list
    @table.reloadData
  end

  def append_email(email)
    @email << email
    #p @list
    @email.reloadData
  end

  def append_phone(phone)
    @phone << phone
    #p @list
    @table.reloadData
  end

  def kid_table
    @table = UITableView.alloc.initWithFrame([[0, 0], [self.view.frame.size.width, self.view.frame.size.height]])
    @table.backgroundView = nil
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
      @save_kids = UIButton.buttonWithType(UIButtonTypeCustom)
      @save_kids.setImage(UIImage.imageNamed('save_button'), forState:UIControlStateNormal)
      @save_kids.setImage(UIImage.imageNamed('save_button'), forState:UIControlStateHighlighted)
      @save_kids.addTarget(self, action: "create_guardian", forControlEvents: UIControlEventTouchUpInside)
      @save_kids.frame = CGRectMake(0, 0, 320, 56)

      @barView = UIBarButtonItem.alloc.initWithCustomView(@save_kids)
      items.addObject(@barView)

      @bottombar.setItems(items, animated: true)
      view.addSubview(@bottombar)
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
  	@reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier)
    cell = UITableViewCell.alloc.initWithStyle(
        UITableViewCellStyleDefault,
        reuseIdentifier: @reuseIdentifier)
    
    @text = UITextField.alloc.initWithFrame([[25, 12], [300, 55]])
    @text.font = UIFont.fontWithName("Helvetica", size: 16)

    if (indexPath.section) == 0

      if (indexPath.row) == 0
        p @first
        
        #cell.addSubview(@fname)
        #@first = @first
        #@first.textAlignment = UITextAlignmentLeft
        #@first.placeholder = "First Name"
        #@first.returnKeyType = UIReturnKeyDone
        #cell.addSubview(@first)
      elsif (indexPath.row) == 1
        @last = @text
        @last.textAlignment = UITextAlignmentLeft
        @last.placeholder = "Last Name"
        cell.addSubview(@last)
      elsif (indexPath.row) == 2
        @phone = @text
        @phone.textAlignment = UITextAlignmentLeft
        @phone.keyboardType = UIKeyboardTypePhonePad
        @phone.placeholder = "1234567890"
        cell.addSubview(@phone)
      elsif (indexPath.row) == 3
        @email = @text
        @email.textAlignment = UITextAlignmentLeft
        @email.keyboardType = UIKeyboardTypeEmailAddress
        @email.placeholder = "Email"
        cell.addSubview(@email)
      elsif (indexPath.row) == 4
        @password = @text
        @password.textAlignment = UITextAlignmentLeft
        @password.secureTextEntry = true
        @password.placeholder = "Password"
        cell.addSubview(@password)
      elsif (indexPath.row) == 5
        @confirm = @text
        @confirm.textAlignment = UITextAlignmentLeft
        @confirm.secureTextEntry = true
        @confirm.placeholder = "Confirm Password"
        cell.addSubview(@confirm)
      elsif (indexPath.row) == 6
        @location = UIButton.buttonWithType(UIButtonTypeRoundedRect)
        cell.textLabel.text = "Search Locations"
        cell.font = UIFont.fontWithName("Helvetica", size: 16)
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
        cell.addSubview(@location)
      end
    end

  	cell
  end


  def tableView(tableView, numberOfRowsInSection: section)
  	@data.count
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
  	tableView.deselectRowAtIndexPath(indexPath, animated: true)
    if (indexPath.section) == 0
      if (indexPath.row) == 6
        locations = SearchController.alloc.initWithNibName(nil, bundle:nil)
        self.navigationController.pushViewController(locations, animated: true)
      end
    end
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

	def create_guardian
	 	first = @first.text
	 	last = @last.text
	 	phone = @phone.text
	 	email = @email.text
	 	password = @password.text
	 	confirm = @confirm.text

    data = {user: {first_name: "#{first}", last_name: "#{last}", phone_number: "#{phone}", email: "#{email}"}}

    BW::HTTP.post("http://localhost:3000/users.json", {payload: data}) do |response|
      if response.ok?
        p response.body.to_s
        json = BW::JSON.parse response.body.to_str
          p json
        p "Successful"
      else
        p "not successful" 
      end
    end

	 	self.navigationController.popToRootViewControllerAnimated:YES
	end

  def cancelPad
      @phone.resignFirstResponder
  end
end