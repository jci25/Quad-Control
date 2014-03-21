//
//  DetailViewController.m
//  Quad Control
//
//  Created by Administrator on 3/15/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import "DetailViewController.h"
#import "ControlViewController.h"

@interface DetailViewController () <MKMapViewDelegate>

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
    _mIP.text=_ip;
    NSString *ip = [NSString stringWithFormat:@"http://ip-api.com/json/%@", _ip];
    NSURL *url = [NSURL URLWithString:
                  ip];
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
    _mMap.delegate = self;
    [_mMap setShowsUserLocation:YES];
    //MKUserLocation *userLocation = _mMap.userLocation;
    
    //MKCoordinateRegion region;
    //region.center = userLocation.location.coordinate;
    //region.span = MKCoordinateSpanMake(2.0, 2.0); //Zoom distance
    //region = [_mMap regionThatFits:region];
    //[_mMap setRegion:region animated:YES];
    _mMap.mapType = MKMapTypeStandard;
    //NSLog(@"%@", userLocation.location.coordinate);
    
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [lat floatValue];
    coordinate.longitude = [lon floatValue];
    MKPlacemark *mPlacemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = mPlacemark.coordinate;
    point.title = _name;
    [_mMap addAnnotation:point];
    
    [self zoomToFitMapAnnotations:_mMap];

    
    /*CLGeocoder *myGeoCode = [[CLGeocoder alloc] init];
    
    
    [myGeoCode geocodeAddressString:loca
     
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

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
 
    
    [self zoomToFitMapAnnotations:_mMap];
}


- (void)zoomToFitMapAnnotations:(MKMapView *)mapView {
    if ([mapView.annotations count] == 0) return;
    
    MKUserLocation *userLocation = mapView.userLocation;
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = userLocation.location.coordinate.latitude;
    topLeftCoord.longitude = userLocation.location.coordinate.longitude;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = userLocation.location.coordinate.latitude;
    bottomRightCoord.longitude = userLocation.location.coordinate.longitude;
    
    for(id<MKAnnotation> annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    
    
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    
    // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
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
