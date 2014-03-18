//
//  ViewController.m
//  Quad Control
//
//  Created by Administrator on 3/14/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"


@interface ViewController () <SRWebSocketDelegate, UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _dataArr = [[NSArray alloc] init];
    _mServer.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mConnect:(id)sender {
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"connectSegue"]){
        NSLog(@"seg");
        TableViewController *controller = (TableViewController *)segue.destinationViewController;
        controller.server = _mServer.text;
    }
    
}

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
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:nil];
    _dataArr = [jsonDict objectForKey:@"data"];
    //jsonDict = [dataArr objectAtIndex:0];
    
    for(id rpi in _dataArr){
        jsonDict = rpi;
        for(id key in jsonDict){
            NSLog(@"key=%@ value=%@", key, [jsonDict objectForKey:key]);
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    self.title = @"Connection Closed! (see logs)";
    _webSocket = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
