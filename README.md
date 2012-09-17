# AppEngine Channel API / Objective-C Library (ARC version)

## Usage

  The easiest way to connect to your channel server is

    AppEngineChannel *appEngineChannel = [[AppEngineChannel alloc] initWithDelegate:self];
    [appEngineChannel connectWithToken:token baseURL:[NSURL URLWithString:@"http://localhost:8080/"]];

  All delegate methods are optional - you could implement the following

    - (void) appEngineChannelDidConnect:(AppEngineChannel *)channel;
    - (void) appEngineChannelDidDisconnect:(AppEngineChannel *)channel;
    - (void) appEngineChannel:(AppEngineChannel *)channel didReceiveMessage:(NSDictionary *)message;
    - (void) appEngineChannel:(AppEngineChannel *)channel didReceiveError:(NSDictionary *)error;

## Authors

  Jun Kikuchi

## Copyright

  Copyright (c) 2012 Jun Kikuchi. See LICENSE for details.