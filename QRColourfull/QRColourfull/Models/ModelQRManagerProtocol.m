//
//  ModelQRManagerProtocol.m
//  QRColourfull
//
//  Created by Kian Davoudi-Rad on 2016-05-28.
//  Copyright © 2016 Kian Davoudi. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "ModelQRManagerProtocol.h"
#import "MyQRManagedObject.h"

// SingleToneClass

@interface ModelQRManagerProtocol ()

@property (nonatomic, strong) UIImage* uiimageFromDidOutputSampleBuffer;
@property (nonatomic, strong) NSString* decodedQRMessage;
@property (nonatomic, strong) MyQRManagedObject* QRModel;

- (void) PlayBeepOnSuccess;
- (UIImage*) ExtractQRFromUIImage:(UIImage*) uiimageFromDidOutputSampleBuffer;
- (UIColor*) GeUIColourFromUIimageFromDidOutputSampleBuffer:(UIImage*)uiimageFromDidOutputSampleBuffer;
@end

@implementation ModelQRManagerProtocol: UIView

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.initializeAVFoundationDeviceInputOutPut;
//        self.AddNewCaptureVideoPreviewLayer;
//        self.InitializeMetadataOutput;
    }
    return self;
}

// http://stackoverflow.com/questions/448125/how-to-get-pixel-data-from-a-uiimage-cocoa-touch-or-cgimage-core-graphics/1262893#1262893
// http://stackoverflow.com/questions/158914/cropping-an-uiimage

- (void)setFoundMatchWithTopLeftPoint:(CGPoint)topLeftPoint topRightPoint:(CGPoint)topRightPoint bottomLeftPoint:(CGPoint)bottomLeftPoint bottomRightPoint:(CGPoint)bottomRightPoint bufferImage:(UIImage*) bufferImage decodedQRMessage:(NSString*) decodedQRMessage{
    NSLog(@"TestUIViewIsRunning");
    NSLog(@"%@",decodedQRMessage);
    
}

@end

