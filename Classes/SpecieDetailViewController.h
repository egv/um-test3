//
//  SpecieDetailViewController.h
//  Test3
//
//  Created by Gennady Evstratov on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequestDelegate.h"

@interface SpecieDetailViewController : UIViewController <ASIHTTPRequestDelegate> {
	UIImageView *iconView;
	UILabel *titleLabel;
	UILabel *detailsLabel;
    UIScrollView *scrollView;
    UIView *detailsBackground;
    
	NSMutableDictionary *rowData;
}

@property (nonatomic, retain) IBOutlet UIImageView *iconView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *detailsLabel;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *detailsBackground;

@property (nonatomic, retain) NSMutableDictionary *rowData;

- (void)imageLoaded:(NSNotification*)notification;

@end
