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

#define R0 95

@implementation AboutViewController

@synthesize scoreLabel;
@synthesize myArc;
@synthesize myBall;

@synthesize firstAttitude;


- (CGFloat)normAngle:(CGFloat)angle {
    CGFloat res = angle;

    while (res < 0){
        res += M_PI*2;
    }
    
    while (res >= M_PI*2){
        res -= M_PI*2;
    }

    return res;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    modv = 3.0;
    valpha = M_PI/8;
    self.myBall.center = CGPointMake(100, 250);
    score = 0;
    self.myArc.image = [UIImage imageNamed:@"test-arc"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
    
    if (motionManager.isDeviceMotionAvailable) {
        opQ = [NSOperationQueue currentQueue];
        [motionManager startDeviceMotionUpdatesToQueue:opQ withHandler:^(CMDeviceMotion *motion, NSError *error) {
            if (self.firstAttitude == nil) {
                NSLog(@"remembering the first attitude");
                self.firstAttitude = motion.attitude;
            } else {
                [motion.attitude multiplyByInverseOfAttitude:self.firstAttitude];
                CGAffineTransform t = CGAffineTransformMakeRotation(motion.attitude.yaw);
                self.myArc.transform = t;

                CGFloat newy = self.myBall.center.y - modv*sin(valpha);
                CGFloat newx = self.myBall.center.x + modv*cos(valpha);

                CGFloat lX = newx - 160;
                CGFloat lY = (-1.0 * (newy - 291));
                // check if ball is beyoung the circle
                if (pow(lX, 2) + pow(lY, 2) >= R0*R0) {
                    // check if it is in the bat area
                    
                    // new reflection tests
                    
                    
                    
                    
                    CGFloat nYaw = M_PI/2 - motion.attitude.yaw; //[self normAngle:motion.attitude.yaw*3];
                    
                    CGFloat batA;
                    if (lX == 0) {
                        batA = lY > 0? M_PI/2 : -M_PI/2;
                    } else {
                        CGFloat at = atan(lY/lX);
                        batA = lX < 0 ? M_PI - at : at; 
                    }
                    
                    CGFloat nBat = [self normAngle:batA];
                    
                    CGFloat bit = M_PI / 8;
                    //NSLog(@"nbat: %.03f, yaw: %.03f, bit: %.03f", nBat, nYaw, bit);
                    //if (nBat > nYaw - bit && nBat < nYaw + bit ) {
                        // we are beyond the circle
                        // put them on it in the first place                    
                        
                        CGFloat R = sqrtf(pow(lX, 2) + pow(lY, 2));                
                        if (R > R0) {
                            lX = lX * R0 / R;
                            lY = lY * R0 / R;
                        }
                        
                        CGFloat phi;
                        if (lX == 0) {
                            phi = M_PI / 2 * (lY > 0 ? 1.0 : -1.0);
                        } else {
                            phi = -1.0 * atanf(lX/lY);
                        }
                    
                    NSLog(@"%@", NSStringFromCGPoint(CGPointApplyAffineTransform(CGPointMake(lX, lY), CGAffineTransformMakeRotation(M_PI/2+phi))));
                    newx = 160 + lX;
                    newy = 291 - lY;
                        NSLog(@"x: %f, y: %f, phi: %f", lX, lY, phi);
                        valpha = [self normAngle:(M_PI + 2 * (M_PI - phi) - valpha)];
                        
                        //NSLog(@"valpha: %f", valpha);
                /*    
                } else {
                       score += 1;
                        self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
                        modv = 1.0;
                        valpha = M_PI/7;
                        newx = 100;
                        newy = 250;
                    }
                */    
                }
                self.myBall.center = CGPointMake(newx, newy);
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"You device is uncapable of handling motion events"
                                                       delegate:nil
                                              cancelButtonTitle:@"Too sad"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        [motionManager release];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if (motionManager) {
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
    self.scoreLabel = nil;
    self.myArc = nil;
    self.myBall = nil;
}


- (void)dealloc {
    [myArc release];
	[scoreLabel release];
    [firstAttitude release];
    [myBall release];
    
    [super dealloc];
}


@end
