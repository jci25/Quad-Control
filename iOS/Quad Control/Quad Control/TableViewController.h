//
//  TableViewController.h
//  Quad Control
//
//  Created by Administrator on 3/15/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"

@interface TableViewController : UIViewController <UITableViewDataSource>

@property SRWebSocket *webSocket;
@property NSArray *data;
@property NSString *server;

@end
