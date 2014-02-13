class EditKidsController < UIViewController
	attr_accessor :user

	def initWithUser(user)
		initWithNibName(nil, bundle:nil)
		self.user = user
		user = @user
		self
	end 

	def viewDidLoad
		super
		self.title = "Edit Kids"
		self.view.backgroundColor = UIColor.colorWithRed(0.8706, green:0.8980, blue:0.9294, alpha: 1)
	    
	    @list ||= []

    	screen_layout
    	kid_table
	end

	def screen_layout
		BW::HTTP.get("http://localhost:3000/users/#{@user}/children.json") do |response|
			  	if response.ok?
				  	json = BW::JSON.parse response.body.to_str
				  	json.each do |item|
				  		if item["user_id"] == @user
				  			first = item["first_name"]

				  			#photo = item["image"]

				  			append_list(first)
				  			#append_picture(photo)		
				  		else
				  		  next
				  		end			  		
				  	end
				else
					warn "POP UP LOGIN"
					
				end	
			end	

	    
	end

	def append_list(list)
		@list << list
		p @list
		@table.reloadData
	end
	def kid_table
		@table = UITableView.alloc.initWithFrame([[0, 0], [self.view.frame.size.width, self.view.frame.size.height]])
		self.view.addSubview(@table)

		@table.delegate = self
		@table.dataSource = self
	end

	def tableView(tableView, cellForRowAtIndexPath: indexPath)
		@reuseIdentifier ||= "CELL_IDENTIFIER"

		cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier)
		cell = UITableViewCell.alloc.initWithStyle(
				UITableViewCellStyleDefault,
				reuseIdentifier: @reuseIdentifier)
		
		cell.textLabel.text = @list[indexPath.row]
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
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
					
	#def tableView(tableView, didSelectRowAtIndexPath: indexPath)
		#controller = SettingsController.alloc.initWithNibName(nil, bundle: nil)
    	#self.navigationController.pushViewController(controller, animated: true)
	#end

	def tableView(tableView, heightForRowAtIndexPath: indexPath)
		100
	end

end