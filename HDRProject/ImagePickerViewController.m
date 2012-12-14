//
//  ImagePickerViewController.m
//  iOS HDR
//
//  Created by Julien G on 11/10/12.
//  Copyright (c) 2012 com.julienportfolio. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
//#import "AVCaptureDevice.h"


@interface ImagePickerViewController ()
@end

@implementation ImagePickerViewController
@synthesize appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

//        UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
//        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
//        cameraUI.showsCameraControls = FALSE;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    exposureValues = [[UISegmentedControl alloc]init];
    inputImage = [[CIImage alloc] initWithImage:originalImageView.image];
    exposureAdjustFilter = [CIFilter filterWithName:@"CIExposureAdjust"];
    [exposureAdjustFilter setDefaults];
    [exposureAdjustFilter setValue: inputImage forKey: @"inputImage"];
    context = [CIContext contextWithOptions:nil];
    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)hasSelectedASegment:(UISegmentedControl *)sender {    
    [self applyContrastWithThisEv:[[sender titleForSegmentAtIndex:[sender selectedSegmentIndex]]integerValue]];
}

- (void) applyContrastWithThisEv:(NSInteger)aEv{
    NSLog(@"Ev is %i",aEv);
    

    [exposureAdjustFilter setValue:[NSNumber numberWithInteger:aEv]
                            forKey:@"inputEV"];

    outputImage = [exposureAdjustFilter valueForKey: @"outputImage"];
    filteredImageView.image = [UIImage imageWithCGImage:[context
                                                    createCGImage:outputImage
                                                    fromRect:outputImage.extent]];
    NSLog(@"DONE");

    
}


- (IBAction) showCameraUI {
    NSLog(@"showCameraUI");

    [self startCameraControllerFromViewController: self
                                    usingDelegate: self];
     }

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil)){
        NSLog(@"aborted");
        return NO;
    }
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;

    cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:
                                            UIImagePickerControllerSourceTypeCamera];
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
//    cameraUI.showsCameraControls = NO;
    cameraUI.delegate = delegate;
    [controller presentViewController: cameraUI animated: YES completion:nil];
    
    return YES;

}


- (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
//    // First get the image into your data buffer
//    CGImageRef imageRef = [image CGImage];
//    if (imageRef == nil) {
//        NSLog(@"cacouille");
//        return nil;
//    }
//    NSUInteger width = CGImageGetWidth(imageRef);
//    NSUInteger height = CGImageGetHeight(imageRef);
//    NSLog(@" %i and %i", width, height);
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
//    NSUInteger bytesPerPixel = 4;
//    NSUInteger bytesPerRow = bytesPerPixel * width;
//    NSUInteger bitsPerComponent = 8;
//    CGContextRef aContext = CGBitmapContextCreate(rawData, width, height,
//                                                 bitsPerComponent, bytesPerRow, colorSpace,
//                                                 kCGImageAlphaPremultipliedLast);
//    
//    if (aContext == nil) {
//        return nil;
//    }
//    
//    CGColorSpaceRelease(colorSpace);
//    
//    CGContextDrawImage(aContext, CGRectMake(0, 0, width, height), imageRef);
//    CGContextRelease(aContext);
//    
//    // Now your rawData contains the image data in the RGBA8888 pixel format.
//    int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
//    for (int ii = 0 ; ii < count ; ++ii)
//    {
//        NSMutableDictionary * aRGBAPixel = [[NSMutableDictionary alloc]init];
//        [aRGBAPixel setValue:[NSNumber numberWithFloat:(rawData[byteIndex]     * 1.0)] forKey:@"red"];
//        [aRGBAPixel setValue:[NSNumber numberWithFloat:(rawData[byteIndex + 1] * 1.0)] forKey:@"green"];
//        [aRGBAPixel setValue:[NSNumber numberWithFloat:(rawData[byteIndex + 2] * 1.0)] forKey:@"blue"];
//        [aRGBAPixel setValue:[NSNumber numberWithFloat:(rawData[byteIndex + 3] * 1.0)] forKey:@"alpha"];
//        byteIndex += 4;
//        [result addObject: aRGBAPixel];
//        
//    }
//    free(rawData);
    return result;
}


- (BOOL)isWallPixel: (UIImage *)image: (int) x :(int) y {
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);

    int pixelInfo = ((image.size.width  * y) + x ) * 4; // The image is png
    
    //UInt8 red = data[pixelInfo];         // If you need this info, enable it
    //UInt8 green = data[(pixelInfo + 1)]; // If you need this info, enable it
    //UInt8 blue = data[pixelInfo + 2];    // If you need this info, enable it
    UInt8 alpha = data[pixelInfo + 3];     // I need only this info for my maze game
    CFRelease(pixelData);
    
    
    if (alpha) return YES;
    else return NO;
}

- (IBAction)showMePixelsValues:(UIButton *)sender {
    
//    NSArray *result = [[NSArray alloc]init];
//    UIImage *evaMendes = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"damier" ofType:@"jpg"]];
//    
//    
//    result= [self getRGBAsFromImage:evaMendes atX:0 andY:0 count:200];
//    NSLog(@"lenght of result=%i",[result count]);
//    NSLog(@"result is= %@",result);
    
    
    UIImage *monDamier = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"landscape16001200" ofType:@"jpg"]];
    imageRef         = [monDamier CGImage];
    
    width            = CGImageGetWidth(imageRef);
    height           = CGImageGetHeight(imageRef);
    colorSpace  = CGColorSpaceCreateDeviceRGB();
    rawData      = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    bytesPerPixel    = 4;
    bytesPerRow      = bytesPerPixel * width;
    bitsPerComponent = 8;
    aContext       = CGBitmapContextCreate(rawData, width, height,
                                           bitsPerComponent, bytesPerRow, colorSpace,
                                           kCGImageAlphaPremultipliedLast);
    
//    if (aContext == nil)
//        return -1.0;
    
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(aContext, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(aContext);
    
//    NSArray* monArray = [[NSArray alloc]init];
//    monArray = [self getArrayOfDataBlockForImage:monDamier];
    NSMutableDictionary* myTwoCGPoints = [[NSMutableDictionary alloc]initWithCapacity:2];
    myTwoCGPoints = [self getCGPointsToFocus:[self getArrayOfDataBlockForImage:monDamier]];
    NSLog(@"le point le plus brillant est en x=%f et y=%f",[[myTwoCGPoints objectForKey:@"theBrightestPoint"]CGPointValue].x,
                                                            [[myTwoCGPoints objectForKey:@"theBrightestPoint"]CGPointValue].y);
    NSLog(@"le point le plus sombre est en x=%f et y=%f",[[myTwoCGPoints objectForKey:@"theDarkestPoint"]CGPointValue].x,
                                                        [[myTwoCGPoints objectForKey:@"theDarkestPoint"]CGPointValue].y);
    
    
}



- (CGPoint) theDarkestAreaOfThiImage:(UIImage*) aImage{
    return CGPointZero;
}



- (float) getLumOfPixelOfImage:(UIImage*)aImage InX:(int)x andY:(int)y{

//    NSLog(@"{x,y}={%i,%i}",x,y);
    byteIndex               = (bytesPerRow * x) + y * bytesPerPixel;
//    if (x>1198) {
//        NSLog(@"[x=%i] byteIndex = %i",x,byteIndex);
//    }
    lux                   = rawData[byteIndex];
    lux     +=rawData[byteIndex+1];
    lux     +=rawData[byteIndex+2];
    lux = lux/3;
    return lux;
}


- (int) PGCDBetweenWidth:(NSInteger)aWidth andHeight:(NSInteger)aHeight{
    NSInteger r;
    while (aHeight != 0){
        r = aWidth % aHeight;
        aWidth = aHeight;
        aHeight = r;
    }
    return aWidth;
}

- (NSMutableDictionary *) getInfoBlocPixelOfImage:(UIImage*)aImage InX:(int)x andY:(int)y andSize:(int)size{
    NSMutableDictionary* infoBlock  = [[NSMutableDictionary alloc]initWithCapacity:2];
    [infoBlock                      setObject:[NSValue valueWithCGPoint:CGPointMake(x+size/2,y+size/2)]
                                       forKey:@"middlePoint"];
    float lum = 0;
    
    for (int i=y; i<y+size; i++) {
        for (int j=x; j<x+size; j++) {
            if (j>1180) {
                //NSLog(@"getlum at x=%i and y=%i",j,i);
            }
            lum += [self getLumOfPixelOfImage:aImage InX:j andY:i];
//            NSLog(@"line number %i",j);
        }
//        NSLog(@"column number %i",i);

    }
    [infoBlock                      setObject:[NSNumber numberWithFloat:lum]
                                       forKey:@"luminosity"];
    return infoBlock;
    
}
- (NSMutableArray*) getArrayOfDataBlockForImage: (UIImage*) aImage{
    imageRef         = [aImage CGImage];
    if (imageRef == nil)
        return nil;
    
    int sizeBlock               = 10;//[self PGCDBetweenWidth:width andHeight:height];
    int nbBlock                 = (width/sizeBlock)*(height/sizeBlock);
    //NSLog(@"sizeBlock=%i",sizeBlock);
    //NSLog(@"width=%i",width);
    //NSLog(@"height=%i",height);
    //NSLog(@"nbBlock=%i",nbBlock);

    
    NSMutableArray *myArray     = [[NSMutableArray alloc]initWithCapacity:nbBlock];
    for (int H=0; H<(height-sizeBlock); H+=sizeBlock) { //on descend d'un bloc
        for (int W=0; W<(width-sizeBlock); W+=sizeBlock) { //on translate d'un bloc
            //NSLog(@"getInfoBlocPixelOfImage at x=%i and y=%i with sizeof %i",W,H,sizeBlock);
            [myArray addObject:[self getInfoBlocPixelOfImage:aImage InX:H andY:W andSize:sizeBlock]];
        }
    }
    //NSLog(@"ArrayFinished");
    return myArray;
}



- (NSMutableDictionary *) getCGPointsToFocus:(NSMutableArray *) aArrayOfDataBlock{
    NSMutableDictionary* myTwoCGPoints = [[NSMutableDictionary alloc] initWithCapacity:2];
    int indexlumBasse       =0;
    int indexlumHaute       =0;
    float lumBasse          =0.0;
    float lumHaute          =0.0;

    for (int i=0; i<[aArrayOfDataBlock count]; i++) {
        float aLuminosity   = [[[aArrayOfDataBlock objectAtIndex:i]objectForKey:@"luminosity"]floatValue];
        if (aLuminosity>=lumBasse) {
            lumBasse        = aLuminosity;
            indexlumBasse   = i;
        }
        if (aLuminosity<=lumHaute) {
            lumHaute        = aLuminosity;
            indexlumHaute   = i;
        }
    }
    //NSLog(@"Getting the point...");
    [myTwoCGPoints setObject:[[aArrayOfDataBlock objectAtIndex:indexlumBasse]
                              objectForKey:@"middlePoint"]forKey:@"theDarkestPoint"];
    [myTwoCGPoints setObject:[[aArrayOfDataBlock objectAtIndex:indexlumHaute]
                              objectForKey:@"middlePoint"]forKey:@"theBrightestPoint"];


    return myTwoCGPoints;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissModalViewControllerAnimated:YES];
    filteredImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSDictionary *myMetaData = [info objectForKey:UIImagePickerControllerMediaMetadata];
    
    
    imageRef         = [[info objectForKey:UIImagePickerControllerOriginalImage]CGImage];
    
    width            = CGImageGetWidth(imageRef);
    height           = CGImageGetHeight(imageRef);
    colorSpace  = CGColorSpaceCreateDeviceRGB();
    rawData      = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    bytesPerPixel    = 4;
    bytesPerRow      = bytesPerPixel * width;
    bitsPerComponent = 8;
    aContext       = CGBitmapContextCreate(rawData, width, height,
                                           bitsPerComponent, bytesPerRow, colorSpace,
                                           kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(aContext, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(aContext);
    
    NSMutableDictionary* myTwoCGPoints = [[NSMutableDictionary alloc]initWithCapacity:2];
    myTwoCGPoints = [self getCGPointsToFocus:[self getArrayOfDataBlockForImage:[info objectForKey:UIImagePickerControllerOriginalImage]]];
    NSLog(@"le point le plus brillant est en x=%f et y=%f",[[myTwoCGPoints objectForKey:@"theBrightestPoint"]CGPointValue].x,
          [[myTwoCGPoints objectForKey:@"theBrightestPoint"]CGPointValue].y);
    NSLog(@"le point le plus sombre est en x=%f et y=%f",[[myTwoCGPoints objectForKey:@"theDarkestPoint"]CGPointValue].x,
          [[myTwoCGPoints objectForKey:@"theDarkestPoint"]CGPointValue].y);
    
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"About This Image"
                                                          message:[NSString stringWithFormat:@"le point le plus brillant est en x=%f et y=%f \n le point le plus sombre est en x=%f et y=%f \n\n metadata = %@",
                                                            [[myTwoCGPoints objectForKey:@"theBrightestPoint"]CGPointValue].x,
                                                            [[myTwoCGPoints objectForKey:@"theBrightestPoint"]CGPointValue].y,
                                                            [[myTwoCGPoints objectForKey:@"theDarkestPoint"]CGPointValue].x,
                                                            [[myTwoCGPoints objectForKey:@"theDarkestPoint"]CGPointValue].y,
                                                            myMetaData]
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:nil, nil];
    
    [myAlertView show];

    

}




@end
