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
- (UIColor *) colorAtPixel:(CGPoint)point inImage:(UIImage *)image;
@end

@implementation ModelQRManagerProtocol: UIView

// Animation Layer
 BOOL _set;
 CAShapeLayer *_shapeLayer;

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
            // Initialization code
//            self.matchFoundColor = [UIColor redColor];
//            self.scanningColor = [UIColor whiteColor];
//            self.backgroundColor = [UIColor clearColor];
//            
//            self.minMatchBoxHeight = 10.0f;
        
            _shapeLayer = [CAShapeLayer layer];
            _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
//            _shapeLayer.strokeColor = [self.scanningColor CGColor];
            _shapeLayer.lineWidth = 2.0;
            _shapeLayer.fillRule = kCAFillRuleNonZero;
            _shapeLayer.frame = self.bounds;
            [self.layer addSublayer:_shapeLayer];
            
            [self reset];

    }
    return self;
}



- (UIColor *)colorAtPixel:(CGPoint)point inImage:(UIImage *)image {
    
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), point)) {
        return nil;
    }
    
    // Create a 1x1 pixel byte array and bitmap context to draw the pixel into.
    //UIImage *rotatedImage = [originalImage imageRotatedByDegrees:90.0];
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = image.CGImage;
    NSUInteger width = image.size.width;
    NSUInteger height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData, 1, 1, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

// http://stackoverflow.com/questions/448125/how-to-get-pixel-data-from-a-uiimage-cocoa-touch-or-cgimage-core-graphics/1262893#1262893
// http://stackoverflow.com/questions/158914/cropping-an-uiimage

- (void)setFoundMatchWithTopLeftPoint:(CGPoint)topLeftPoint topRightPoint:(CGPoint)topRightPoint bottomLeftPoint:(CGPoint)bottomLeftPoint bottomRightPoint:(CGPoint)bottomRightPoint bufferImage:(UIImage*) bufferImage decodedQRMessage:(NSString*) decodedQRMessage{
    NSLog(@"TestUIViewIsRunning");
    NSLog(@"%@",decodedQRMessage);
    
    UIColor * testColour = [self colorAtPixel: topLeftPoint inImage:bufferImage];
    CGSize testSize = CGSizeMake(100.1, 100.1); //alloc]init];
    UIImage *testImage =  [self imageWithColor:testColour size:testSize];
    UIImage * PortraitImage = [self imageRotatedByDegrees: bufferImage deg:90.0];
    CGRect cropRect = CGRectMake(topLeftPoint.x,topLeftPoint.y,1000,100);
    CGImageRef imageRef = CGImageCreateWithImageInRect([PortraitImage CGImage], cropRect);
    // or use the UIImage wherever you like
    UIImage *TestCopped = [UIImage imageWithCGImage:imageRef];
    //CGImageRelease(imageRef);

}


- (UIImage*) imageWithColor:(UIColor*)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    UIBezierPath* rPath = [UIBezierPath bezierPathWithRect:CGRectMake(0., 0., size.width, size.height)];
    [color setFill];
    [rPath fill];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



- (UIImage *)imageRotatedByDegrees:(UIImage*)oldImage deg:(CGFloat)degrees{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oldImage.size.width, oldImage.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, (degrees * M_PI / 180));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-oldImage.size.width / 2, -oldImage.size.height / 2, oldImage.size.width, oldImage.size.height), [oldImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)reset {
    [_shapeLayer removeAllAnimations];
//    _shapeLayer.strokeColor = [self.scanningColor CGColor];
    _set = NO;
    [self setNeedsLayout];
}
@end

