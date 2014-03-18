//
//  DetailViewController.m
//  Quad Control
//
//  Created by Administrator on 3/15/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import "DetailViewController.h"
#import "ControlViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //_ip = @"50.182.71.123";
    _mIP.text = _ip;
    
    NSURL *url = [NSURL URLWithString:
                  [@"http://ip-api.com/json/" stringByAppendingString:_ip]];
    NSData* data = [NSData dataWithContentsOfURL:
                    url];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    NSString* currentIP = [json objectForKey:@"query"];
    NSString* lat = [json objectForKey:@"lat"];
    NSString* lon = [json objectForKey:@"lon"];
    
    [_mMap setShowsUserLocation:YES];
    MKUserLocation *userLocation = _mMap.userLocation;
    MKCoordinateRegion region;
    //region.center = userLocation.location.coordinate;
    //region.span = MKCoordinateSpanMake(2.0, 2.0); //Zoom distance
    //region = [_mMap regionThatFits:region];
    //[_mMap setRegion:region animated:YES];
    _mMap.mapType = MKMapTypeStandard;
    NSLog(@"%@", userLocation.location.coordinate);
    
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [lat floatValue];
    coordinate.longitude = [lon floatValue];
    MKPlacemark *mPlacemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    [_mMap addAnnotation:mPlacemark];
    
    CLGeocoder *myGeoCode = [[CLGeocoder alloc] init];
    
    /*[myGeoCode geocodeAddressString:loca
     
                  completionHandler:^(NSArray *placemarks, NSError *error) {
                      CLPlacemark *whatPlaceIsThis = placemarks[0];
                      
                      if([placemarks count] != 0){
                          
                          
                          MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
                          annotation.coordinate  = whatPlaceIsThis.location.coordinate;
                          annotation.title = [NSString stringWithFormat:@"%@ %@", [currR objectAtIndex:2], [currR objectAtIndex:3]];
                          [_myMap addAnnotation:annotation];
                          [_myMap setRegion:MKCoordinateRegionMakeWithDistance(whatPlaceIsThis.location.coordinate, 1000, 1000) animated:YES];
                      }
                      
                  }];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"controlSegue"]){
        NSLog(@"seg");
        ControlViewController *controller = (ControlViewController *)segue.destinationViewController;
        controller.mIP = _ip;
        controller.mKey = _key;
        controller.server = _server;
    }
    
}

- (IBAction)mControl:(id)sender {
}
@end
