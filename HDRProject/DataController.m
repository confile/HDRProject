//
//  DataController.m
//  iOS HDR
//
//  Created by Julien G on 25/10/12.
//  Copyright (c) 2012 com.julienportfolio. All rights reserved.
//

#import "DataController.h"
#import "AppDelegate.h"


static DataController *sharedInstance;

@implementation DataController

+ (DataController *)sharedInstance {
    if(sharedInstance == nil)
        sharedInstance = [[DataController alloc] init];
    return sharedInstance;
}

- (id)init {
	
	self = [super init];
    if (self != nil) {
        appDelegate     = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    }
	return self;
}










@end
