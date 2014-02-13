class UpdateKidController < UIViewController
	attr_accessor :edit_kid_controller #change back to add_kid_

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

	    
	    @data = {
	    	"Personal Information" => ["First Name", "Last Name", "Birthdate"],
	    	"Additional Information" => ["Allergens"]}

	    @updatelist ||= []
	    
	    get_kids
	    kid_table

	end

	def get_kids
		BW::HTTP.get("http://localhost:3000/users/#{@user}/children.json") do |response|
			  	if response.ok?
				  	json = BW::JSON.parse response.body.to_str
				  	json.each do |item|
				  		if item["user_id"] == @user
				  			
				  			first = item["first_name"]
				  			last


				  			#photo = item["image"]

				  			append_list(first)
				  			#append_picture(photo)		
				  		else
				  		  next
				  		end			  		
				  	end
				else
					warn "NOT GOOD!!!"
				end	
			end	

	    
	end

	def append_list(updatelist)
		@updatelist << list
		#p @list
		@table.reloadData
	end

	def kid_table
	    @table = UITableView.alloc.initWithFrame(self.view.bounds, style: UITableViewStyleGrouped)
	    @table.backgroundView = nil
	    self.view.addSubview(@table)

	    @table.delegate = self
	    @table.dataSource = self
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



		@text = UITextField.alloc.initWithFrame([[25, 12], [300, 55]])
    	@text.font = UIFont.fontWithName("Helvetica", size: 16)

		if (indexPath.section) == 0

			if (indexPath.row) == 0
				@kidfirst = @text
		        @kidfirst.textAlignment = UITextAlignmentLeft
		        @kidfirst.placeholder = "First Name"
		        @kidfirst.returnKeyType = UIReturnKeyDone
		        cell.addSubview(@first)
			elsif (indexPath.row) == 1
				@kidlast = @text
		        @kidlast.textAlignment = UITextAlignmentLeft
		        @kidlast.placeholder = "Last Name"
		        cell.addSubview(@kidlast)
			elsif (indexPath.row) == 2
				@kidbdate = @text
		        @kidbdate.textAlignment = UITextAlignmentLeft
		        @kidbdate.placeholder = "Last Name"
		        cell.addSubview(@kidbdate)
			end
		end

		if (indexPath.section) == 1

			if (indexPath.row) == 0
				@kidallergens #= UIButton.buttonWithType(UIButtonTypeRoundedRect)
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
				cell.addSubview(@kidallergens)
			end
		end

		#cell.textLabel.text = row_for_index_path(indexPath)
		cell
	end
					
	def tableView(tableView, didSelectRowAtIndexPath: indexPath)
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		if (indexPath.section) == 1
			if (indexPath.row) == 0
				allergens = AllergensController.alloc.initWithNibName(nil, bundle:nil)
				self.navigationController.pushViewController(allergens, animated: true)
			elsif (indexPath.row) == 1
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