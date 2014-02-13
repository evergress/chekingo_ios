class AllergensController < UIViewController
	def viewDidLoad
		super
		self.title = "Allergens"
		@table = UITableView.alloc.initWithFrame(self.view.bounds, 
			style: UITableViewStyleGrouped)
		@table.autoresizingMask = UIViewAutoresizingFlexibleHeight
	    view.addSubview(@table)

	    @table.dataSource = self
	    @table.delegate = self

	    @data = { 
	    	"Food" => ["Fruit", "Milk", "Peanuts"], #{}"Soy", "Gluten", "Oats", "Wheat", "Egg"],
	    	"Environmental" => ["Insect Sting", "Animals", "Mold"], #{}"Perfume", "Cosmetics"],
	    	"Other" => []}

	    @selected_cells = []

	end

	def tableView(tableView, numberOfRowsInSection: section)
		@data.count
	end

	def tableView(tableView, cellForRowAtIndexPath: indexPath)
		@reuseIdentifier ||= "CELL_IDENTIFIER"

		@cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier)
		@cell = UITableViewCell.alloc.initWithStyle(
				UITableViewCellStyleDefault,
				reuseIdentifier: @reuseIdentifier)

		@cell.textLabel.text = row_for_index_path(indexPath)
		@cell.selectionStyle = UITableViewCellSelectionStyleNone
		@cell
	end


					
	def tableView(tableView, didSelectRowAtIndexPath: indexPath)
		#tableView.deselectRowAtIndexPath(indexPath, animated: true)
		  if tableView.cellForRowAtIndexPath(indexPath).accessoryType == UITableViewCellAccessoryCheckmark
            tableView.cellForRowAtIndexPath(indexPath).accessoryType = UITableViewCellAccessoryNone
            @selected_cells.delete(tableView.cellForRowAtIndexPath(indexPath).text)
            p @selected_cells
          else
          	tableView.cellForRowAtIndexPath(indexPath).accessoryType = UITableViewCellAccessoryCheckmark
		    @selected_cells << tableView.cellForRowAtIndexPath(indexPath).text
		    p @selected_cells	
		  end
	end



	#def select
	#	if @cell.accessoryType == UITableViewCellAccessoryNone
	#		@cell.accessoryType = UITableViewCellAccessoryCheckmark
	#		@cell.selected = true
	#	else
	#		@cell.accessoryType = UITableViewCellAccessoryNone
	#		@cell.selected = nil
	#	end
	#end



	#def select_allergnes
	#	@select = UITableViewCell.alloc.init.tap do |check|
	#	check.accessoryType = UITableViewCellAccessoryCheckmark
	#	end
	#end

	def select
		@data.values.each
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