//
//  AppDelegate.h
//  HDRProject
//
//  Created by Julien on 14/12/12.
//  Copyright (c) 2012 juliengoudet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePickerViewController.h"
#import "DataController.h"

@class DataController;
@class ImagePickerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    DataController              *dataController;
    ImagePickerViewController   *myImageViewController;
}

@property (strong, nonatomic) DataController            *dataController;
@property (strong, nonatomic) ImagePickerViewController *myImageViewController;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

