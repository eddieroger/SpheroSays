//
//  ViewController.h
//  SpheroSays
//
//  Created by Eddie Roger on 12/30/13.
//  Copyright (c) 2013 Eddie Roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    BOOL _robotOnline;
    BOOL _ledState;
}

// Sphero Hookup Things
-(void)setupRobotConnection;
-(void)handleRobotOnline;
-(void)foregroundHandler;
-(void)backgroundHandler;

// My App Things
-(void)toggleLED;
@end
