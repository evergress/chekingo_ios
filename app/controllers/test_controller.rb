class TestController < UIViewController
	attr_accessor :user

	def initWithUser(user)
		initWithNibName(nil, bundle:nil)
		self.user = user
		user = @user
		self
	end 

	def viewDidLoad
		super

		self.title = "Add Kids"
		self.navigationController.navigationBarHidden = false
		self.navigationItem.hidesBackButton = true
		self.view.backgroundColor = UIColor.whiteColor


		@leftSaveButton = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
			UIBarButtonSystemItemSave,
			target: self,
			action: 'chekin')
		self.navigationItem.leftBarButtonItem = @leftSaveButton

		@rightAddButon = UIBarButtonItem.alloc.initWithImage(
			UIImage.imageNamed("add.png"),
			style: UIBarButtonItemStylePlain,
			target: self,
			action: 'kid_setup')
		self.navigationItem.rightBarButtonItem = @rightAddButon


    	#@data = {
    	#	'@list' => [""],
    	#	'@picture' => [""]
    	#}

    	#@list ||= []

    	@picture ||= []

      	screen_layout

      	@selected_kids = []

	end

	def kid_setup
		
		controller = KidSetupController.alloc.init
		controller.store_user_id(@user)
		self.presentViewController(
			UINavigationController.alloc.initWithRootViewController(controller),
			animated: true,
			completion: lambda{})
	end

	#def kid_setup
	#	controller = KidSetupController.alloc.init
	#	controller.store_user_id(@user)
	#	self.navigationController.pushViewController(controller, animated: true)  
	#end

	def screen_layout
		BW::HTTP.get("http://localhost:3000/users/#{@user}/children.json") do |response|
			  	if response.ok?
				  	json = BW::JSON.parse response.body.to_str
				  	json.each do |item|
				  		if item["user_id"] == @user
				  			#first = item["first_name"]

				  			photo = item["image"]

				  			#append_list(first)
				  			append_picture(photo)		
				  		else
				  		  next
				  		end			  		
				  	end
				else
					warn "NOT GOOD!!!"
				end	
			end	

			@picture.each do |pic|
			image_view = UIImageView.initWithData(pic)
			image_view.frame = [[0,0],[200,300]]
			self.view.addSubview(image_view)
		end


	end

	#def append_list(list)
	#	@list << list
	#	p @list
	#	view.reloadData
	#end

	def append_picture(picture)
		@picture << picture
		
		#view.reloadData
	end

	def chekin
		@selected_kids.each do |kid|
			SelectedKids.create(:name => kid)
		end
		confirmation = ConfirmationController.alloc.initWithNibName(nil, bundle:nil)
        self.navigationController.pushViewController(confirmation, animated: true)
	end


		 	
end