//
//  DataController.h
//  iOS HDR
//
//  Created by Julien G on 25/10/12.
//  Copyright (c) 2012 com.julienportfolio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@class AppDelegate;

@interface DataController : NSObject{
    AppDelegate*        appDelegate;
    NSMutableDictionary*    medianlevelImage;
    UIImage*            medianImage;
    UIImage*            lowImage;
    UIImage*            highImage;

}

+ (DataController *)sharedInstance;




@end
