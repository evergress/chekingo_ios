class SettingsController < UIViewController
	attr_accessor :user

	def initWithUser(user)
		initWithNibName(nil, bundle:nil)
		self.user = user
		user = @user
		self
	end 

	def viewDidLoad
		super
		self.title = "Settings"
		self.view.backgroundColor = UIColor.colorWithRed(0.8706, green:0.8980, blue:0.9294, alpha: 1)
	    
	    @data = {
	    	"Account Info" => ["Edit Account Information", "Link Other Guardians"],
	    	"Kids" => ["Edit Kids Information"]}

	    kid_table

	end

	def kid_table
		@table = UITableView.alloc.initWithFrame([[0, 0], 
			[self.view.frame.size.width, self.view.frame.size.height]])
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



		@text = UITextField.alloc.initWithFrame([[140, 12], [160, 50]])
		@text.font = UIFont.fontWithName("Helvetica", size:16) #District Pro

		if (indexPath.section) == 0

			if (indexPath.row) == 0
				@parent = UIButton.buttonWithType(UIButtonTypeRoundedRect)
		        cell.textLabel.text = "Edit Account Information"
		        cell.font = UIFont.fontWithName("Helvetica", size: 16)
		        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
		        cell.addSubview(@parent)
			elsif (indexPath.row) == 1
				@other_guardian = UIButton.buttonWithType(UIButtonTypeRoundedRect)
		        cell.textLabel.text = "Link Other Gardians"
		        cell.font = UIFont.fontWithName("Helvetica", size: 16)
		        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
		        cell.addSubview(@other_guardian)
			end
		end

		if (indexPath.section) == 1

			if (indexPath.row) == 0
				@edit_kids #= UIButton.buttonWithType(UIButtonTypeRoundedRect)
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
				cell.addSubview(@edit_kids) 
			end
		end

		cell.textLabel.text = row_for_index_path(indexPath)
		cell
	end
					
	def tableView(tableView, didSelectRowAtIndexPath: indexPath)
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		if (indexPath.section) == 0
			if (indexPath.row) == 0
#				BW::HTTP.get("http://localhost:3000/users.json") do |response|
#		        if response.ok?
#		          json = BW::JSON.parse response.body.to_str
#		          json.each do |item|
#		              	@id = item[:id]
						parents = EditParentController.alloc.initWithNibName(nil, bundle:nil)
						self.navigationController.pushViewController(parents, animated: true)
#						end
#					end
#				end
				
			elsif (indexPath.row) == 1
				gardians = LinkGuardianController.alloc.initWithNibName(nil, bundle:nil)
				self.navigationController.pushViewController(gardians, animated: true)
			end
		end

		if (indexPath.section) == 1
			if (indexPath.row) == 0
				BW::HTTP.get("http://localhost:3000/users.json") do |response|
		        if response.ok?
		          json = BW::JSON.parse response.body.to_str
		          json.each do |item|
		              	@id = item[:id]
						controller = EditKidsController.alloc.initWithUser(@id)
						self.navigationController.pushViewController(controller, animated: true)
						end
					end
				end
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