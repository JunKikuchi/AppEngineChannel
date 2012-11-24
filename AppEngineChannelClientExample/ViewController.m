//
//  ViewController.m
//  AppEngineChannelClientExample
//
//  Created by 菊池 淳 on 12/08/29.
//  Copyright (c) 2012年 Jun Kikuchi. All rights reserved.
//

#import "ViewController.h"

NSString *base_url = @"http://localhost:8080/";

@interface ViewController ()

@end

@implementation ViewController {
    AppEngineChannel *appEngineChannel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *url = [base_url stringByAppendingString:@"channel?client_id=aaa"];
    NSLog(@"request channel token URL: %@", url);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSString *token = [dict objectForKey:@"token"];
        appEngineChannel = [[AppEngineChannel alloc] initWithDelegate:self];
        [appEngineChannel connectWithToken:token baseURL:[NSURL URLWithString:base_url]];
    } else {
        NSLog(@"local server is not working");
    }
}

- (void)viewDidUnload
{
    [self setCountLabel:nil];
    [self setStartButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)appEngineChannelDidConnect:(AppEngineChannel *)channel {
    NSLog(@"appEngineChannelDidConnect: %@", channel);
    self.countLabel.text = @"ready!";
    self.startButton.enabled = YES;
}

- (void)appEngineChannelDidDisconnect:(AppEngineChannel *)channel {
    NSLog(@"appEngineChannelDidDisconnect: %@", channel);
}

- (void)appEngineChannel:(AppEngineChannel *)channel didReceiveMessage:(NSDictionary *)message {
    NSLog(@"appEngineChannel: %@ didReceiveMessage: %@", channel, message);

    NSError *error;
    NSData *data = [[message objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSLog(@"appEngineChannel: %@ json: %@", channel, json);
    
    NSInteger num = [((NSNumber *)[json objectForKey:@"message"])integerValue];
    NSString *url = [base_url stringByAppendingFormat:@"channel/count?num=%d", num];
    [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    self.countLabel.text = [NSString stringWithFormat:@"%d", num];
}

- (void)appEngineChannel:(AppEngineChannel *)channel didReceiveError:(NSDictionary *)error {
    NSLog(@"appEngineChannel: %@ didReceiveError: %@", channel, error);
}

- (IBAction)startButtonTapped:(id)sender {
    NSString *url = [base_url stringByAppendingString:@"channel/count?num=0"];
    [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
}

@end
