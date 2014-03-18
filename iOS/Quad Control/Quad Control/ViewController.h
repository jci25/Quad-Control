//
//  ViewController.h
//  Quad Control
//
//  Created by Administrator on 3/14/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mServer;
@property SRWebSocket *webSocket;
@property NSArray *dataArr;
- (IBAction)mConnect:(id)sender;

@end
