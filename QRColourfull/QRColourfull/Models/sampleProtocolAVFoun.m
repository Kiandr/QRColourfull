//
//  cusProtocolAVFoun.m
//  QRColourfull
//
//  Created by Kian Davoudi-Rad on 2016-05-25.
//  Copyright © 2016 Kian Davoudi. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "sampleProtocolAVFoun.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AnimationViewProtocol.h"
@interface sampleProtocolAVFoun () <AVCaptureMetadataOutputObjectsDelegate, AnimationViewProtocolDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) NSDate *lastDetectionDate;
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;
@property (nonatomic, strong) AnimationViewProtocol *animationView;
@property (nonatomic, strong) AVCaptureDevice *avCaptureDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *avCaptureDeviceInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *avCaptureVideoDataOutput;
@property (nonatomic, strong) dispatch_queue_t videoDataOutputQueue;
@property (nonatomic, strong) dispatch_queue_t audioDataOutputQueue;
@property (nonatomic, strong) UIImage *realtimeUIImageFromCaptureOutputDelegateMethod;


@end


@implementation sampleProtocolAVFoun

#pragma Initialization
// Init Implementation delegate method (May25th2016)
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.initializeAVFoundationDeviceInputOutPut;
        self.AddNewCaptureVideoPreviewLayer;
        self.InitializeMetadataOutput;
    }
    return self;
}
- (void)start {
    //    if (!_scanning) {
    //        _scanning = YES;
    //     [self.matchView reset];
    [self.captureSession startRunning];
    
    
    //        if ([self.delegate respondsToSelector:@selector(scannerViewDidStartScanning:)]) {
    //            [self.delegate scannerViewDidStartScanning:self];
    //        }
    //n    }
    
}
- (void)stop {
    //    if (_scanning) {
    //        _scanning = NO;
    //        [_timer invalidate];
    //        _timer = nil;
    [self.captureSession stopRunning];
    //
    //        if ([self.delegate respondsToSelector:@selector(scannerViewDidStopScanning:)]) {
    //            [self.delegate scannerViewDidStopScanning:self];
    //        }
    //    }
}
- (void)layoutSubviews {
    // Delegate Method us being updated constantly.
    [super layoutSubviews];
    self.previewLayer.frame = self.bounds;
}
#pragma Initalize davice input/output/UIImage Delgature buffer
// May27th201 initalize davice input/output/UIImage Delgature buffer
- (void) initializeAVFoundationDeviceInputOutPut{
    
    NSError *error;
    
    // Initialization code
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    
    _avCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _avCaptureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_avCaptureDevice error:&error];
    
    
    if ([_avCaptureDevice lockForConfiguration:&error]) {
        if (_avCaptureDevice.isAutoFocusRangeRestrictionSupported) {
            [_avCaptureDevice setAutoFocusRangeRestriction:AVCaptureAutoFocusRangeRestrictionNear];
        }
        if ([_avCaptureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [_avCaptureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        [_avCaptureDevice unlockForConfiguration];
    } else {
        NSLog(@"Could not configure video capture device: %@", error);
    }
    

    _avCaptureVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    if ([self.captureSession canAddOutput:_avCaptureVideoDataOutput] ) {
        [self.captureSession addOutput:_avCaptureVideoDataOutput];
        NSDictionary *newSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
        self.avCaptureVideoDataOutput.videoSettings = newSettings;
        
        // discard if the data output queue is blocked (as we process the still image
        [self.avCaptureVideoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
        _videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
        [self.avCaptureVideoDataOutput setSampleBufferDelegate:self queue:_videoDataOutputQueue];
        
    if ([self.captureSession canAddInput:_avCaptureDeviceInput])
        [self.captureSession addInput:_avCaptureDeviceInput];
    }
}
-(void) InitializeMetadataOutput{
    
    self.metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:self.metadataOutput];
    [self.metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeQRCode]];

}
-(void)AddNewCaptureVideoPreviewLayer{

self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
[self.layer addSublayer:self.previewLayer];

}

#pragma setLocalVariables
// set local variable from the delegate method (May25,2016)
- (void)setMetadataObjectTypes:(NSArray *)metaDataObjectTypes {
    [self.metadataOutput setMetadataObjectTypes:metaDataObjectTypes];
}

#pragma mark sampleProtocolAVFounDelegateSampleFunction
-(void)startSampleProcess{
    
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self.delegate
                                   selector:@selector(processCompleted) userInfo:nil repeats:NO];
}
- (CGPoint)pointFromArray:(NSArray *)points atIndex:(NSUInteger)index{NSDictionary *dict = [points objectAtIndex:index];
    CGPoint point;
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)dict, &point);
    return [self.animationView convertPoint:point fromView:self];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    // Delegate method is being called.
    for(AVMetadataObject *metadataObject in metadataObjects)
    {
        if ([metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            AVMetadataMachineReadableCodeObject *readableObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
            BOOL foundMatch = readableObject.stringValue != nil;
            NSString *string = readableObject.stringValue;
            NSLog(@"%@",string);
            NSArray *corners = readableObject.corners;
            if (corners.count == 4 && foundMatch) {
                
                CGPoint topLeftPoint = [self pointFromArray:corners atIndex:0];
                CGPoint bottomLeftPoint = [self pointFromArray:corners atIndex:1];
                CGPoint bottomRightPoint = [self pointFromArray:corners atIndex:2];
                CGPoint topRightPoint = [self pointFromArray:corners atIndex:3];
                
                if (CGRectContainsPoint(self.animationView.bounds, topLeftPoint) &&
                    CGRectContainsPoint(self.animationView.bounds, topRightPoint) &&
                    CGRectContainsPoint(self.animationView.bounds, bottomLeftPoint) &&
                    CGRectContainsPoint(self.animationView.bounds, bottomRightPoint))
                {
                    [self stop];
                    //_timer = [NSTimer scheduledTimerWithTimeInterval:self.quietPeriodAfterMatch target:self selector:@selector(start) userInfo:nil repeats:NO];
                    self.lastDetectionDate = [NSDate date];
                    
                    [self.animationView setFoundMatchWithTopLeftPoint:topLeftPoint
                                                        topRightPoint:topRightPoint
                                                      bottomLeftPoint:bottomLeftPoint
                                                     bottomRightPoint:bottomRightPoint];
                    //[self.delegate scannerView:self didReadCode:readableObject.stringValue];
                }
            }
        }
    }
}

#pragma mark - Protocol AVCaptureVideoDataOutputSampleBufferDelegate
// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    // Create a UIImage from the sample buffer data
    NSLog(@"Delegate routine that is called when a sample buffer was written");
    // image for Open cv
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
    // Process Image in Bus Layer
    
    //    dispatch_sync(dispatch_get_main_queue(), ^{
    //        _imageLayer.contents = (__bridge id)self.returnImagProceecedWithOpenCv.CGImage;
    //        _customPreviewLayer.contents = (__bridge id)self.returnImagProceecedWithOpenCv.CGImage;
    //    });
    //
    
    
    
}

// Create a UIImage from sample buffer data
- (UIImage*) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer {
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

#pragma mark - Encapsulation - Getters
// GetBuffredImage encapsulation
- (UIImage*) getrealtimeUIImageFromCaptureOutputDelegateMethod{
    
    UIImage *retrunObject = nil;
    
    if (_realtimeUIImageFromCaptureOutputDelegateMethod)
    retrunObject =  _realtimeUIImageFromCaptureOutputDelegateMethod;

    return retrunObject;
}
@end

