//
//  SpeciesViewController.h
//  Test3
//
//  Created by Gennady Evstratov on 8/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequestDelegate.h"

@class MBProgressHUD;

@interface SpeciesViewController : UITableViewController <ASIHTTPRequestDelegate> {
	NSArray *tableData;
	MBProgressHUD *progressHUD;
}

@property (nonatomic, retain) NSArray *tableData;
@property (nonatomic, retain) MBProgressHUD *progressHUD;

- (IBAction)refreshPressed:(id)sender;

@end
