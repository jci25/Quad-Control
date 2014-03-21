//
//  TableViewController.m
//  Quad Control
//
//  Created by Administrator on 3/15/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import "TableViewController.h"
#import "DetailViewController.h"
#import "MapViewController.h"

@interface TableViewController () <SRWebSocketDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TableViewController

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
    self.tableView.dataSource = self;
    //self.title = @"Opening Connection...";
    [_webSocket open];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //5
    static NSString *cellIdentifier = @"SettingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSLog(@"yup");
    //NSArray *currR = [NSArray arrayWithArray:[_data objectAtIndex:indexPath.row]];
    
    NSDictionary *jsonDict = [_data objectAtIndex:indexPath.row];
    
    
    [cell.textLabel setText:[jsonDict objectForKey:@"Name"]];
    
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"Key: %@", [jsonDict objectForKey:@"Key"]]];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"detailSegue"]){
        NSLog(@"seg");
        DetailViewController *controller = (DetailViewController *)segue.destinationViewController;
        int i = [[self.tableView indexPathForSelectedRow] row];
        NSDictionary *jsonDict = [_data objectAtIndex:i];
        NSString *sendIP = [[jsonDict objectForKey:@"IP"]
                                         stringByReplacingOccurrencesOfString:@"'" withString:@""];
        controller.ip = sendIP;
        controller.key = [jsonDict objectForKey:@"Key"];
        controller.name = [jsonDict objectForKey:@"Name"];
        controller.server = _server;
    }else if ([segue.identifier isEqualToString:@"mapSegue"]){
        MapViewController *controller = (MapViewController *)segue.destinationViewController;
        
        controller.mData = _data;
        controller.server = _server;
    }
    
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    //self.title = @"Connected!";
    [_webSocket send:@"Get"];
    
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    //self.title = @"Connection Failed! (see logs)";
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
    _data = [jsonDict objectForKey:@"data"];
    //jsonDict = [dataArr objectAtIndex:0];
    for(id rpi in _data){
        jsonDict = rpi;
        for(id key in jsonDict){
            NSLog(@"key=%@ value=%@", key, [jsonDict objectForKey:key]);
        }
    }
    [self.tableView reloadData];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    self.title = @"Connection Closed! (see logs)";
    _webSocket = nil;
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
