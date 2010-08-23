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
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "SpecieDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation SpeciesViewController

@synthesize tableData;
@synthesize progressHUD;
@synthesize imageCache;

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate methods

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSURL *origURL = request.originalURL;
    
    NSIndexPath *indexPath = [self.imageCache objectForKey:origURL];
    if (indexPath == nil) {
        // this is main json data
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        self.tableData = [jsonParser objectWithString:[request responseString]];
        [jsonParser release];
        
        [self.tableView reloadData];
    } else {
        // this is image loading
        NSData *imageData = [request responseData];
        UIImage *fullImage = [UIImage imageWithData:imageData];
        UIImage *image = [fullImage resizeToWidth:50.0 andHeight:50.0];
        NSMutableDictionary *rowData = [self.tableData objectAtIndex:indexPath.row];
        [rowData setObject:fullImage forKey:@"__fullImage__"];
        [rowData setObject:image forKey:@"__icon__"];

        // set cell's image
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.imageView.image = image;
        
        // and after all we should send notification with the image url as an user data
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[rowData objectForKey:@"image"] forKey:@"image"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageLoadedNotification" object:nil userInfo:userInfo];
    }
    
    [self.progressHUD hide:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    [self.progressHUD hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Some error prevented us from getting data.\nYou can try to refresh it later."
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark -
#pragma mark actions

- (IBAction)refreshPressed:(id)sender {
    [self.progressHUD show:YES];
    self.imageCache = [NSMutableDictionary dictionary];	
    NSURL *dataURL = [NSURL URLWithString:@"http://unrealmojo.com/porn/test3/"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:dataURL];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)loadImagesForOnscreenRows {
    if ([self.tableData count] > 0) {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
            NSDictionary *rowData = [self.tableData objectAtIndex:indexPath.row];
            UIImage *tmpImage = [rowData objectForKey:@"__icon__"];
            if (tmpImage == nil) {
                [self startImageDownload:[rowData objectForKey:@"image"] forIndexPath:indexPath];
            }
        }
    }
}

- (void)startImageDownload:(NSString*)URLString forIndexPath:(NSIndexPath*)indexPath {
    NSURL *myURL = [NSURL URLWithString:URLString];
    
    if (myURL != nil) {
        NSIndexPath *foo = [self.imageCache objectForKey:myURL];
        if (foo == nil) {
            [self.imageCache setObject:indexPath forKey:myURL];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:myURL];
            [request setDelegate:self];
            [request startAsynchronous];
        }
    }
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD = hud;
    [self.view addSubview:self.progressHUD];
    [hud release];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                   target:self
                                                                                   action:@selector(refreshPressed:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    [refreshButton release];
    
    [self refreshPressed:nil];
}

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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    NSDictionary *rowData = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = [rowData objectForKey:@"title"];
    cell.detailTextLabel.text = [rowData objectForKey:@"description"];
    cell.detailTextLabel.numberOfLines = 2;
    
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 10;
    
    UIImage *image = [rowData objectForKey:@"__icon__"];
    if (image != nil) {
        cell.imageView.image = image;
    } else {
        cell.imageView.image = [UIImage imageNamed:@"Placeholder"];
        NSString *imageURLString = [rowData objectForKey:@"image"];
        if (imageURLString != nil) {
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                [self startImageDownload:imageURLString forIndexPath:indexPath];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *rowData = [self.tableData objectAtIndex:indexPath.row];
    SpecieDetailViewController *viewController = [[SpecieDetailViewController alloc] initWithNibName:@"SpecieDetailViewController" bundle:nil];
    viewController.rowData = rowData;
    [[NSNotificationCenter defaultCenter] addObserver:viewController selector:@selector(imageLoaded:) name:@"ImageLoadedNotification" object:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
    
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [tableData release];
    [progressHUD release];
    [imageCache release];
    
    [super dealloc];
}


@end

