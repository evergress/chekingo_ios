class SearchController < UITableViewController
  def viewDidLoad
    super

    self.view.backgroundColor = UIColor.whiteColor
    @searchcontroller = UISearchBar.alloc.initWithFrame(CGRectMake(0, 0, 320, 44))
    @searchcontroller.backgroundImage = UIImage.imageNamed("search-background")
    @searchcontroller.placeholder = "Locations"
    @searchcontroller.autoresizingMask = UIViewAutoresizingFlexibleWidth
    self.navigationItem.titleView = @searchcontroller
    @searchcontroller.delegate = self

    self.view.delegate = self
    self.view.dataSource = self
    self.view.allowsMultipleSelection = true

    self.view.allowsSelection

    @search_results = []

    read_words

  end

  def read_words
    file = NSBundle.mainBundle.pathForResource("churches", ofType:"txt")
    all_words = NSString.stringWithContentsOfFile(file, encoding:NSUTF8StringEncoding, error:nil)
    @locations = all_words.lines
    @locations.each do |c|
      @search_results << c
    end
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin     
       UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end

    #FONT
    cell.textLabel.font = UIFont.fontWithName("Helvetica", size: 14)

    cell.textLabel.text = @search_results.to_a[indexPath.row]
    #cell.selectionStyle = UITableViewCellSelectionStyleNone


    cell
  end


  def tableView(tableView, numberOfRowsInSection: section)
    @search_results.to_a.count
    #@data.count
  end 

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    #tableView.accessoryType = UITableViewCellAccessoryCheckmark
  end


  def searchBarSearchButtonClicked(searchBar)
    @searchbartext = searchBar.text
    @search_results.clear
    searchBar.resignFirstResponder
    navigationItem.title = "#{searchBar.text}"
    search_for(@searchbartext)
    @searchbartext = ""
  end

  def search_for(text)
    @locations.select do |c|
      if c.include?(text)
        @search_results << c
      end
    end

    view.reloadData
  end


end