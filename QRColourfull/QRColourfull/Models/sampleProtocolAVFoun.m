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

@interface sampleProtocolAVFoun () <AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) NSDate *lastDetectionDate;
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;

@end


@implementation sampleProtocolAVFoun

#pragma sampleProtocolAVFound 
// Init Implementation delegate method (May25th2016)
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.captureSession = [[AVCaptureSession alloc] init];
        [self.captureSession setSessionPreset:AVCaptureSessionPreset640x480];
        
        AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        if ([videoCaptureDevice lockForConfiguration:&error]) {
            if (videoCaptureDevice.isAutoFocusRangeRestrictionSupported) {
                [videoCaptureDevice setAutoFocusRangeRestriction:AVCaptureAutoFocusRangeRestrictionNear];
            }
            if ([videoCaptureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                [videoCaptureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            }
            [videoCaptureDevice unlockForConfiguration];
        } else {
            NSLog(@"Could not configure video capture device: %@", error);
        }
        
        AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
        if(videoInput) {
            [self.captureSession addInput:videoInput];
        } else {
            NSLog(@"Could not create video input: %@", error);
        }
        
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.layer addSublayer:self.previewLayer];

        
        self.metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [self.captureSession addOutput:self.metadataOutput];
        [self.metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [self setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeQRCode]];
        
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
//        [self.captureSession stopRunning];
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
                
//                CGPoint topLeftPoint = [self pointFromArray:corners atIndex:0];
//                CGPoint bottomLeftPoint = [self pointFromArray:corners atIndex:1];
//                CGPoint bottomRightPoint = [self pointFromArray:corners atIndex:2];
//                CGPoint topRightPoint = [self pointFromArray:corners atIndex:3];
                
//                if (CGRectContainsPoint(self.matchView.bounds, topLeftPoint) &&
//                    CGRectContainsPoint(self.matchView.bounds, topRightPoint) &&
//                    CGRectContainsPoint(self.matchView.bounds, bottomLeftPoint) &&
//                    CGRectContainsPoint(self.matchView.bounds, bottomRightPoint))
//                {
//                    [self stop];
//                    _timer = [NSTimer scheduledTimerWithTimeInterval:self.quietPeriodAfterMatch target:self selector:@selector(start) userInfo:nil repeats:NO];
//                    self.lastDetectionDate = [NSDate date];
//                    
//                    [self.matchView setFoundMatchWithTopLeftPoint:topLeftPoint
//                                                    topRightPoint:topRightPoint
//                                                  bottomLeftPoint:bottomLeftPoint
//                                                 bottomRightPoint:bottomRightPoint];
//                    [self.delegate scannerView:self didReadCode:readableObject.stringValue];
                }
            }
        }
    }
@end