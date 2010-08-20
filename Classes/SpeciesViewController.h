//
//  SpeciesViewController.h
//  Test3
//
//  Created by Gennady Evstratov on 8/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequestDelegate.h"

@interface SpeciesViewController : UITableViewController <ASIHTTPRequestDelegate> {
	NSArray *tableData;
}

@property (nonatomic, retain) NSArray *tableData;

- (IBAction)refreshPressed:(id)sender;

@end
