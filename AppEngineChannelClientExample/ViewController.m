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
        appEngineChannel = [[AppEngineChannel alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:8080/"] token:token delegate:self];
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

- (void)appEngineChannelOpen:(AppEngineChannel *)channel {
    NSLog(@"appEngineChannelOpen: %@", channel);
}

- (void)appEngineChannel:(AppEngineChannel *)channel message:(NSDictionary *)message {
    NSLog(@"appEngineChannel: %@ message: %@", channel, message);
}

- (void)appEngineChannel:(AppEngineChannel *)channel error:(NSDictionary *)error {
    NSLog(@"appEngineChannel: %@ error: %@", channel, error);
}

- (void)appEngineChannelClose:(AppEngineChannel *)channel {
    NSLog(@"appEngineChannelClose: %@", channel);
}

@end
