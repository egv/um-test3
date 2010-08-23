//
//  AboutViewController.h
//  Test3
//
//  Created by Gennady Evstratov on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface AboutViewController : UIViewController {
    UILabel *scoreLabel;
    UIImageView *myArc;
    UIImageView *myBall;
    
    CMMotionManager *motionManager;
    NSOperationQueue *opQ;
    CMAttitude *firstAttitude;
    
    CGFloat valpha;
    CGFloat modv;
    
    NSInteger score;
}

@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) IBOutlet UIImageView *myArc;
@property (nonatomic, retain) IBOutlet UIImageView *myBall;
@property (nonatomic, retain) CMAttitude *firstAttitude;


@end
