//
//  ImagePickerViewController.h
//  iOS HDR
//
//  Created by Julien G on 11/10/12.
//  Copyright (c) 2012 com.julienportfolio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"

@class AppDelegate;

@interface ImagePickerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    AppDelegate                     *appDelegate;
    IBOutlet UIImageView            *originalImageView;
    IBOutlet UISegmentedControl     *exposureValues;
    IBOutlet UIImageView            *filteredImageView;
    
    CGImageRef imageRef ;
    unsigned char *rawData;
    NSUInteger width ;
    NSUInteger height ;
    CGColorSpaceRef colorSpace;
    NSUInteger bytesPerPixel;
    NSUInteger bytesPerRow ;
    NSUInteger bitsPerComponent;
    CGContextRef aContext ;
    int byteIndex;
    float lux;
    
    
    CIImage *inputImage;
    CIImage *outputImage;
    CIFilter *exposureAdjustFilter;
    CIContext *context;
    
}

@property (nonatomic, retain) AppDelegate           *appDelegate;

- (void) applyContrastWithThisEv:(NSInteger)aEv;
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate;
- (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count;

- (BOOL)isWallPixel: (UIImage *)image: (int) x :(int) y ;
- (IBAction)showMePixelsValues:(UIButton *)sender;

- (CGPoint) theDarkestAreaOfThiImage:(UIImage*) aImage;


- (float) getLumOfPixelOfImage:(UIImage*)aImage InX:(int)x andY:(int)y;       //retourne la moyenne du RGB (luminosité) du pixel en (x,y)
- (NSMutableDictionary *) getInfoBlocPixelOfImage:(UIImage*)aImage InX:(int)x andY:(int )y andSize:(int)size;  // retourne l'objet InfoBlocPixel correspondant donnant le pixel central et la luminosité générale
- (int) PGCDBetweenWidth:(NSInteger)aWidth andHeight:(NSInteger)aHeight;
- (NSMutableArray*) getArrayOfDataBlockForImage: (UIImage*) aImage;        //retourne un tableau donnant les pixel médian et leur luminosité associé
- (NSMutableDictionary *) getCGPointsToFocus:(NSMutableArray *) aArrayOfDataBlock;  //choisi quel pixel utilisé pour focuser


@end
