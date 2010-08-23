    //
//  AboutViewController.m
//  Test3
//
//  Created by Gennady Evstratov on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>
#import "Test3AppDelegate.h"
#import <MEssageUI/MessageUI.h>

@implementation AboutViewController

@synthesize myArc;

@synthesize firstAttitude;

#pragma mark -
#pragma mark delegate methods

- (void)mailComposeController:(MFMailComposeViewController*)controller 
		  didFinishWithResult:(MFMailComposeResult)result 
						error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
				 didFinishWithResult:(MessageComposeResult)result {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark actions

- (IBAction)sendMail:(id)sender {
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *viewController = [[MFMailComposeViewController alloc] init];
		[viewController setToRecipients:[NSArray arrayWithObject:@"g.evstratov@gmail.com"]];
		[viewController setSubject:@"Hamster says"];
		viewController.mailComposeDelegate = self;
		
		[self presentModalViewController:viewController animated:YES];
		[viewController release];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"noemail", @"You can not send email.")
														message:NSLocalizedString(@"contactmebyemail", @"If you want to contact me please send email to g.evstratov@gmail.com")
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"ok", @"ok")
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (IBAction)sendSms:(id)sender {
	if ([MFMessageComposeViewController canSendText]) {
		MFMessageComposeViewController *viewController = [[MFMessageComposeViewController alloc] init];
		[viewController setRecipients:[NSArray arrayWithObject:@"+79263443443"]];
		[viewController setBody:@""];
		viewController.messageComposeDelegate = self;
		
		[self presentModalViewController:viewController animated:YES];
		[viewController release];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"nosms", @"You can not send SMS.")
														message:NSLocalizedString(@"smscontact", @"If you want to contact me please send SMS to +7 (926) 344-3443.\n(no voice calls please)")
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"ok", @"ok")
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}



- (void)viewDidLoad {
    [super viewDidLoad];    
    self.myArc.image = [UIImage imageNamed:@"hamster"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
    
    if (motionManager.isDeviceMotionAvailable) {
        opQ = [[NSOperationQueue currentQueue] retain];
        [motionManager startDeviceMotionUpdatesToQueue:opQ withHandler:^(CMDeviceMotion *motion, NSError *error) {
            if (self.firstAttitude == nil) {
                NSLog(@"remembering the first attitude");
                self.firstAttitude = motion.attitude;
            } else {
                [motion.attitude multiplyByInverseOfAttitude:self.firstAttitude];
                CGAffineTransform t = CGAffineTransformMakeRotation(motion.attitude.yaw);
                self.myArc.transform = t;
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"nocoremove", @"unable to user CoreMove")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"toosad", @"too sad")
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        [motionManager release];
        motionManager = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if (motionManager != nil) {
        [motionManager stopDeviceMotionUpdates];
        [opQ release];
        [motionManager release];
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.myArc = nil;
}


- (void)dealloc {
    [myArc release];
    [firstAttitude release];
    
    [super dealloc];
}


@end
