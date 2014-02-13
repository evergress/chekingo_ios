class ConfirmationController < UIViewController

	def viewDidLoad
		super

		#self.view.preferredInterfaceOrientationForPresentation = UIInterfaceOrientationLandscapeRight

		#@rightAddButon = UIBarButtonItem.alloc.initWithImage(
		#	UIImage.imageNamed("add.png"),
		#	style: UIBarButtonItemStylePlain,
		#	target: self,
		#	action: 'done')
		#self.navigationItem.rightBarButtonItem = @rightAddButon

		@leftBackButton = UIBarButtonItem.alloc.initWithTitle("Select Kids",
			style: UIBarButtonItemStylePlain,
			target: self,
			action: 'addKids')
		self.navigationItem.leftBarButtonItem = @leftBackButton

	 	@iterate ||= []

		self.confirmation
		self.selected_kids
		self.final_kids
		save_button

	 	#@confirmation = (0...5).map { (rand(9)).to_i }.join
		#@iterate ||= ["#{@confirmation}"]

		#self.confirmation

	end

	def confirmation
		@confirmation = (0...5).map { (rand(9)).to_i }.join

		@confirm = UILabel.alloc.initWithFrame([[0,0],[self.view.frame.size.width, 90]])
		#@confirm.text = "'" + "#{@confirmation}" + "'"
		@confirm.text = "#{@confirmation}"
		@confirm.textAlignment = NSTextAlignmentCenter
		@confirm.textColor = UIColor.redColor
		@confirm.font = UIFont.fontWithName("Helvetica", size: 40)
		@confirm.adjustsFontSizeToFitWidth
		self.view.addSubview(@confirm)

	end

	def selected_kids
		@header = UILabel.alloc.initWithFrame([[0,90], [self.view.frame.size.width, 24]])
		@header.text = "   Selected Kids:"
		@header.backgroundColor = UIColor.colorWithRed(0.9500, green:0.9500, blue:0.9500, alpha: 1)
		@header.textColor = UIColor.colorWithRed(0.7, green:0.7, blue:0.7, alpha: 1)
		@header.font = UIFont.fontWithName("Helvetica", size: 16)
		self.view.addSubview(@header)
	end

	def final_kids
		@selected_kids = SelectedKids.all		
		@selected_kids.each{|k|  @iterate << k.name}
		@table = UITableView.alloc.initWithFrame([[0, 114], [self.view.frame.size.width, self.view.frame.size.height]])
		#@table.tableHeaderView = @header
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
		@save_kids.addTarget(self, action: "done", forControlEvents: UIControlEventTouchUpInside)
		@save_kids.frame = CGRectMake(0, 0, 320, 56)

		@barView = UIBarButtonItem.alloc.initWithCustomView(@save_kids)
		items.addObject(@barView)

		@bottombar.setItems(items, animated: true)
		view.addSubview(@bottombar)
	end

	def tableView(tableView, cellForRowAtIndexPath: indexPath)
		#tableView.separatorStyle = UITableViewCellSeparatorStyleNone
		@reuseIdentifier ||= "CELL_IDENTIFIER"

		cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin     
		UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
	end

		cell.textLabel.text = @iterate[indexPath.row]
		cell.textLabel.font = UIFont.fontWithName("Helvetica", size:16) #District Pro
		#cell.detailTextLabel.text = @confirmation[indexPath.row]
		#cell.imageView.image = @list[indexPath.row]
		cell.selectionStyle = UITableViewCellSelectionStyleNone


		cell
	end


	def tableView(tableView, numberOfRowsInSection: section)
		@iterate.count
		#@data.count
	end 

	#Old
	#def confirmation
	#	@selected_kids = SelectedKids.all


	# 	@selected_kids.each{|k|  @iterate << k.name}
	#end

	def done
		#My way
		SelectedKids.delete
		p @selected_kids

		#Jason's Way:
		#child_clear = SelectedKids.all
		#count = child_clear.count

		#0.upto(count - 1) do |c|
		#	 child_clear[c].delete
		#end
		self.navigationController.popToRootViewControllerAnimated:YES

	end

	def addKids
		SelectedKids.delete
		p @selected_kids

		#To Go Back
		self.navigationController.popViewControllerAnimated:yes

	end

end

	#def done
	#	SelectedKids.delete
	#	p @selected_kids

	#  	self.navigationController.popToRootViewControllerAnimated:YES

	#end

	#end