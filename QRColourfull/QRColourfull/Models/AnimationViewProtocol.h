
//
//  AnimationView.h
//  QRColourfull
//
//  Created by Kian Davoudi-Rad on 2016-05-27.
//  Copyright © 2016 Kian Davoudi. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@protocol AnimationViewProtocolDelegate <NSObject>

@required
- (void) processCompleted;
@end

@interface AnimationViewProtocol : UIView


{
    // Delegate to respond back
    id <AnimationViewProtocolDelegate> _delegate;
}

@property (nonatomic,strong) id delegate;
@property (nonatomic, strong) UIColor *matchFoundColor;
@property (nonatomic, strong) UIColor *scanningColor;
@property (nonatomic, assign) CGFloat minMatchBoxHeight;

- (void)setFoundMatchWithTopLeftPoint:(CGPoint)topLeftPoint topRightPoint:(CGPoint)topRightPoint bottomLeftPoint:(CGPoint)bottomLeftPoint bottomRightPoint:(CGPoint)bottomRightPoint;
- (void)reset;

@end

