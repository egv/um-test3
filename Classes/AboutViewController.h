//
//  AboutViewController.h
//  Test3
//
//  Created by Gennady Evstratov on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <MessageUI/MessageUI.h>

@interface AboutViewController : UIViewController <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate> {
    UIImageView *myArc;
    
    CMMotionManager *motionManager;
    NSOperationQueue *opQ;
    CMAttitude *firstAttitude;
    
}

@property (nonatomic, retain) IBOutlet UIImageView *myArc;
@property (nonatomic, retain) CMAttitude *firstAttitude;

- (IBAction)sendMail:(id)sender;
- (IBAction)sendSms:(id)sender;

@end
