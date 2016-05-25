//
//  customAVFoudDevice.h
//  QRColourfull
//
//  Created by Kian Davoudi-Rad on 2016-05-25.
//  Copyright © 2016 Kian Davoudi. All rights reserved.
//

#import <Foundation/Foundation.h>
// Protocol definition starts here
@protocol sampleProtocolAVFounDelegate <NSObject>

@required
- (void) processCompleted;
@end
// Protocol Definition ends here
@interface sampleProtocolAVFoun : NSObject

{
    // Delegate to respond back
    id <sampleProtocolAVFounDelegate> _delegate;
    
}
@property (nonatomic,strong) id delegate;

-(void)startSampleProcess; // Instance method

@end