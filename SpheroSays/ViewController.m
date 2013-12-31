//
//  ViewController.m
//  SpheroSays
//
//  Created by Eddie Roger on 12/30/13.
//  Copyright (c) 2013 Eddie Roger. All rights reserved.
//

#import "ViewController.h"
#import <RobotKit/RobotKit.h>
#import <RobotUIKit/RobotUIKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _ledState = NO;
	// Do any additional setup after loading the view, typically from a nib.
    
    // Foreground listener
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foregroundHandler)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    // Background listener
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backgroundHandler)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [self connectToRobot];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toggleLED
{
    if (_ledState) {
        // Turn them off
        [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:0.0 blue:0.0];
    } else {
        [RKRGBLEDOutputCommand sendCommandWithRed:1.0 green:1.0 blue:1.0];
    }
    
    _ledState = !_ledState;
    [self performSelector:@selector(toggleLED) withObject:nil afterDelay:1.0]; // Loops this process.
}


-(void)foregroundHandler
{
    [self connectToRobot];
}

-(void)backgroundHandler
{
    // Stop listening for device connections
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:RKDeviceConnectionOnlineNotification
                                                  object:nil];
    
    // Turn off LEDs
    [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:0.0 blue:0.0];

    // Disconnect from Sphero
    [[RKRobotProvider sharedRobotProvider] closeRobotConnection];

}

-(void)connectToRobot
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRobotOnline)
                                                 name:RKDeviceConnectionOnlineNotification
                                               object:nil];
    if ([[RKRobotProvider sharedRobotProvider] isRobotUnderControl]) {
        [[RKRobotProvider sharedRobotProvider] openRobotConnection];
    } else {
        [[RKRobotProvider sharedRobotProvider] controlConnectedRobot];
    }
}

-(void)handleRobotOnline
{
    if (!_robotOnline) {
        // Bleep bloop command loop.
        [self toggleLED];
    }
    
    _robotOnline = YES;
}

@end
