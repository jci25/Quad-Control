//
//  ControlViewController.h
//  Quad Control
//
//  Created by Administrator on 3/15/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"

@interface ControlViewController : UIViewController
- (IBAction)slider:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *mRoll;
@property (weak, nonatomic) IBOutlet UISlider *mPitch;
@property (weak, nonatomic) IBOutlet UISlider *mThrottle;
@property (weak, nonatomic) IBOutlet UISlider *mYaw;

@property SRWebSocket *webSocket;

@property NSString *mIP;
@property NSString *mKey;
@property NSString *server;


@end
