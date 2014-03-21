//
//  MapViewController.m
//  Quad Control
//
//  Created by Administrator on 3/19/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import "MapViewController.h"
#import "DetailViewController.h"

@interface MapViewController () <MKMapViewDelegate>

@end

@implementation MapViewController

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
    _mMap.delegate = self;
    [_mMap setShowsUserLocation:YES];
    _mMap.mapType = MKMapTypeStandard;
    
    for (int i = 0; i < _mData.count; i++) {
        NSDictionary *jsonDict = [_mData objectAtIndex:i];
        
        NSString *ip =[jsonDict objectForKey:@"IP"];
        ip = [ip stringByReplacingOccurrencesOfString:@"'" withString:@""];
        NSURL *url = [NSURL URLWithString:
                      [@"http://ip-api.com/json/" stringByAppendingString:ip]];
        NSData* data = [NSData dataWithContentsOfURL:
                        url];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        NSLog(@"%@", json);
        NSString* currentIP = [json objectForKey:@"query"];
        NSString* lat = [json objectForKey:@"lat"];
        NSString* lon = [json objectForKey:@"lon"];
        
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [lat floatValue];
        coordinate.longitude = [lon floatValue];
        MKPlacemark *mPlacemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = mPlacemark.coordinate;
        point.title = [jsonDict objectForKey:@"Name"];
        
        [_mMap addAnnotation:point];

        
    }
    [self zoomToFitMapAnnotations:_mMap];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MyLocation";
    @try {
        if ([annotation.title isEqualToString:@"Current Location"]) {
            return nil;
        }else{
        MKPinAnnotationView *annotationView =
        (MKPinAnnotationView *)[_mMap dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc]
                              initWithAnnotation:annotation
                              reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        // Create a UIButton object to add on the
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        [annotationView setRightCalloutAccessoryView:rightButton];
        
        
        
        return annotationView;
        }
    }
    @catch (NSException *exception) {
        return nil;
    }
    
    
    
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    if ([(UIButton*)control buttonType] == UIButtonTypeDetailDisclosure){
        // Do your thing when the detailDisclosureButton is touched
        //DetailViewController *mapDetailViewController = [[DetailViewController alloc] init];
        //[[self navigationController] pushViewController:mapDetailViewController animated:YES];
        [self performSegueWithIdentifier:@"detailSegue" sender:self];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"detailSegue"]){
        NSLog(@"seg");
        DetailViewController *controller = (DetailViewController *)segue.destinationViewController;
        int i = [_mMap.selectedAnnotations count]-1;
        
        NSDictionary *jsonDict = [_mData objectAtIndex:i];
        NSLog(@"mapview %@", [jsonDict objectForKey:@"IP"]);
        NSString *sendIP = [[jsonDict objectForKey:@"IP"]
                            stringByReplacingOccurrencesOfString:@"'" withString:@""];
         NSLog(@"mapview %@", sendIP);
        controller.ip = sendIP;
        controller.key = [jsonDict objectForKey:@"Key"];
        controller.name = [jsonDict objectForKey:@"Name"];
        controller.server = _server;
    }
    
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

@end
