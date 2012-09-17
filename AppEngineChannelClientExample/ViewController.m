//
//  ViewController.m
//  AppEngineChannelClientExample
//
//  Created by 菊池 淳 on 12/08/29.
//  Copyright (c) 2012年 Jun Kikuchi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    AppEngineChannel *appEngineChannel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://localhost:8080/channel?client_id=aaa"]];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSString *token = [dict objectForKey:@"token"];
        appEngineChannel = [[AppEngineChannel alloc] initWithDelegate:self];
        [appEngineChannel connectWithToken:token baseURL:[NSURL URLWithString:@"http://localhost:8080/"]];
    } else {
        NSLog(@"local server is not working");
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)appEngineChannelDidConnect:(AppEngineChannel *)channel {
    NSLog(@"appEngineChannelDidConnect: %@", channel);
}

- (void)appEngineChannelDidDisconnect:(AppEngineChannel *)channel {
    NSLog(@"appEngineChannelDidDisconnect: %@", channel);
}

- (void)appEngineChannel:(AppEngineChannel *)channel didReceiveMessage:(NSDictionary *)message {
    NSLog(@"appEngineChannel: %@ didReceiveMessage: %@", channel, message);
}

- (void)appEngineChannel:(AppEngineChannel *)channel didReceiveError:(NSDictionary *)error {
    NSLog(@"appEngineChannel: %@ didReceiveError: %@", channel, error);
}

@end
