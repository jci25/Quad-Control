//
//  MapViewController.h
//  Quad Control
//
//  Created by Administrator on 3/19/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mMap;
@property NSArray *mData;
@property NSString *server;

@end
