//
//  SpeciesViewController.m
//  Test3
//
//  Created by Gennady Evstratov on 8/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SpeciesViewController.h"
#import "JSON.h"
#import "UIImage+Resize.h"

@implementation SpeciesViewController

@synthesize tableData;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	NSURL *dataURL = [NSURL URLWithString:@"http://unrealmojo.com/porn/test3/"];
	NSString *dataString = [NSString stringWithContentsOfURL:dataURL];
	
	SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
	self.tableData = [jsonParser objectWithString:dataString];
	[jsonParser release];
	
	[self.tableView reloadData];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.tableData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *rowData = [self.tableData objectAtIndex:indexPath.row];
	cell.textLabel.text = [rowData objectForKey:@"title"];
	cell.detailTextLabel.text = [rowData objectForKey:@"description"];
	cell.detailTextLabel.numberOfLines = 2;
	
	NSString *imageURLString = [rowData objectForKey:@"image"];
	UIImage *image;
	if (imageURLString != nil) {
		NSURL *imageURL = [NSURL URLWithString:imageURLString];
		NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
		image = [[UIImage imageWithData:imageData] thumbnailImage:50
												transparentBorder:2
													 cornerRadius:10
											 interpolationQuality:kCGInterpolationHigh];
	} else {
		image = [UIImage imageNamed:@"Placeholder.png"];
	}
	cell.imageView.image = image;
	
    return cell;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[tableData release];
	
    [super dealloc];
}


@end

