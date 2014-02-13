class LocationsController < UIViewController
	def viewDidLoad
		super
		self.title = "Select Locations"
		self.view.backgroundColor = UIColor.clearColor
		
		@table = UITableView.alloc.initWithFrame(self.view.bounds, 
			style: UITableViewStyleGrouped)
		@table.autoresizingMask = UIViewAutoresizingFlexibleHeight
	    view.addSubview(@table)

	    @table.dataSource = self
	    @table.delegate = self

	    @data = { 
	    	"Select Locations That Apply" => ["Union Grove Baptish Chruch", "Kernersville Wesleyan Church", "Oak Ridge Elementary"]}

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

		if (indexPath.section) == 0

			if (indexPath.row) == 0
				@ug = UILabel.alloc.initWithFrame(CGRectZero)
				cell.addSubview(@ug)
			elsif (indexPath.row) == 1
				@kwc = UILabel.alloc.initWithFrame(CGRectZero)
				@kwc.textAlignment = UITextAlignmentRight
				cell.addSubview(@kwc)
			elsif (indexPath.row) == 2
				@or = UILabel.alloc.initWithFrame(CGRectZero)
				@or.textAlignment = UITextAlignmentRight
				cell.addSubview(@or)
			end
		end

		cell.textLabel.text = row_for_index_path(indexPath)
		cell
	end

	def tableView(tableView, didSelectRowAtIndexPath: indexPath)
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
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

end