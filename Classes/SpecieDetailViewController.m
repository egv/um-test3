//
//  SpecieDetailViewController.m
//  Test3
//
//  Created by Gennady Evstratov on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SpecieDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SpecieDetailViewController (Private)

- (void)setUpIconView;

@end

@implementation SpecieDetailViewController

@synthesize rowData;
@synthesize detailsBackground, scrollView, iconView, detailsLabel, titleLabel;

- (void)setUpIconView {
    UIImage *fullImage = [self.rowData objectForKey:@"__fullImage__"];
    
    CGFloat newHeight = 0;
    if (fullImage != nil) {
        CGSize imageSize = fullImage.size;
        newHeight = 280 * imageSize.height / imageSize.width;
        
        self.iconView.hidden = NO;
        self.iconView.image = [self.rowData objectForKey:@"__fullImage__"];
        self.iconView.layer.masksToBounds = YES;
        self.iconView.layer.cornerRadius = 10;
    } else {
        // display hud if we are still loading this one
        self.iconView.hidden = YES;
        NSString *imageURLString = [rowData objectForKey:@"image"];
        if (imageURLString != nil) {
            // show hud
        }
    }
    
    self.iconView.frame = CGRectMake(20, 56, 280, newHeight);
    self.detailsLabel.frame = CGRectMake(25, 56 + newHeight + 8 + 5, 270, self.detailsLabel.frame.size.height);
    self.detailsBackground.frame = CGRectMake(20, 56 + newHeight + 8 , 280, self.detailsLabel.frame.size.height + 10);
    self.scrollView.contentSize = CGSizeMake(320, 56 + newHeight + 8 + self.detailsLabel.frame.size.height + 10);
}

- (void)imageLoaded:(NSNotification*)notification {
    NSLog(@"got notification, userInfo: %@", notification);
    if ([[notification.userInfo objectForKey:@"image"] isEqualToString:[self.rowData objectForKey:@"image"]]) {
        [self setUpIconView];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = [self.rowData objectForKey:@"title"];
	
	self.titleLabel.text = [self.rowData objectForKey:@"title"];
	self.detailsLabel.text = [self.rowData objectForKey:@"description"];
    self.detailsLabel.numberOfLines = 0;
    self.detailsLabel.lineBreakMode = UILineBreakModeWordWrap;

    self.detailsBackground.layer.cornerRadius = 10;
    self.detailsBackground.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.detailsBackground.layer.borderWidth = 3;
    
    CGSize neededSize = [[self.rowData objectForKey:@"description"] sizeWithFont:self.detailsLabel.font
                                                               constrainedToSize:CGSizeMake(270, 10000)
                                                                   lineBreakMode:UILineBreakModeWordWrap];
    self.detailsLabel.frame = CGRectMake(25, 61, 270, neededSize.height);
    self.detailsBackground.frame = CGRectMake(20, 56, 280, neededSize.height + 10);
    
    [self setUpIconView];
	
	self.titleLabel.layer.cornerRadius = 10;
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scrollView = nil;
    self.iconView = nil;
    self.titleLabel = nil;
    self.detailsLabel = nil;
    self.detailsBackground = nil;
}


- (void)dealloc {
	[rowData release];
	
	[iconView release];
	[titleLabel release];
	[detailsLabel release];
    [scrollView release];
    [detailsBackground release];
	
    [super dealloc];
}


@end
