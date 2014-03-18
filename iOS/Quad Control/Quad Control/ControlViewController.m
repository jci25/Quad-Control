//
//  ControlViewController.m
//  Quad Control
//
//  Created by Administrator on 3/15/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import "ControlViewController.h"

@interface ControlViewController () <SRWebSocketDelegate>
@property float froll;
@property float fPitch;
@property float fThrottle;
@property float fYaw;
@end

@implementation ControlViewController

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
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_server]]];
    _webSocket.delegate = self;
    self.title = @"Opening Connection...";
    [_webSocket open];
    self.froll = 0;
    self.fPitch = 0;
    self.fThrottle = 0;
    self.fYaw = 0;
    

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



#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    self.title = @"Connected!";
    
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    self.title = @"Connection Failed! (see logs)";
    _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"Received \"%@\"", message);
    
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    self.title = @"Connection Closed! (see logs)";
    _webSocket = nil;
}

- (IBAction)slider:(id)sender {
    NSLog(@"%@ %f %f %f %f .053", _mKey, _mRoll.value, _mPitch.value, _mThrottle.value, _mYaw.value);
    int run = 0;
    float froll = (_mRoll.value * .0205) + .053;
    float fPitch = (_mPitch.value * .0205) + .053;
    float fThrottle = (_mThrottle.value * .0205) + .053;
    float fYaw = (_mYaw.value * .0205) + .053;
    if(fabsf(self.froll - froll) > .001){
        self.froll = froll;
        run = 1;
    }else if(fabsf(self.fPitch - fPitch) > .001){
        self.fPitch = fPitch;
        run = 1;
    }else if(fabsf(self.fThrottle - fThrottle) > .001){
        self.fThrottle = fThrottle;
        run = 1;
    }else if(fabsf(self.fYaw - fYaw) > .001){
        self.fYaw = fYaw;
        run = 1;
    }
        
    NSString *roll = [[NSNumber numberWithFloat:self.froll] stringValue];
    NSString *pitch = [[NSNumber numberWithFloat:self.fPitch] stringValue];
    NSString *throttle = [[NSNumber numberWithFloat:self.fThrottle] stringValue];
    NSString *yaw = [[NSNumber numberWithFloat:self.fYaw] stringValue];
    
    NSString *ppm = [_mKey stringByAppendingString:@" "];
    ppm = [ppm stringByAppendingString:roll];
    ppm = [ppm stringByAppendingString:@" "];
    ppm = [ppm stringByAppendingString:pitch];
    ppm = [ppm stringByAppendingString:@" "];
    ppm = [ppm stringByAppendingString:throttle];
    ppm = [ppm stringByAppendingString:@" "];
    ppm = [ppm stringByAppendingString:yaw];
    ppm = [ppm stringByAppendingString:@" .053"];
    //NSString *ppm = [@"%@ %f %f %f %f .053", _mKey, _mRoll.value, _mPitch.value, _mThrottle.value, _mYaw.value];
    NSLog(@"%d", run);
    if(run == 1){
        NSLog(@"HEHEHEHEHEHEHEHEHHEH");
        [_webSocket send:ppm];
    }
}
@end
