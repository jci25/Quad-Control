//
//  DetailViewController.h
//  Quad Control
//
//  Created by Administrator on 3/15/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DetailViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *mIP;
- (IBAction)mControl:(id)sender;
@property (weak, nonatomic) IBOutlet MKMapView *mMap;
@property NSString *ip;
@property NSString *key;
@property NSString *server;
@property NSString *name;

@end
