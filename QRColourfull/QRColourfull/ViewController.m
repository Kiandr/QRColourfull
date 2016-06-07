//
//  ViewController.m
//  QRColourfull
//
//  Created by Kian Davoudi-Rad on 2016-05-24.
//  Copyright © 2016 Kian Davoudi. All rights reserved.
//

#import "ViewController.h"
#import "sampleProtocolAVFoun.h"
#import "ModelQRManagerProtocol.h"

@interface ViewController ()<sampleProtocolAVFounDelegate>

@property (nonatomic, strong) sampleProtocolAVFoun *sampleProtocolUIView;
@property (nonatomic, strong) ModelQRManagerProtocol *QRManagerUIView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.sampleProtocolUIView = [[sampleProtocolAVFoun alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.QRManagerUIView = [[ModelQRManagerProtocol alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    self.sampleProtocolUIView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.sampleProtocolUIView.delegate = self;
    
    [self.view addSubview:self.sampleProtocolUIView];
    [self.view addSubview:self.QRManagerUIView];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.sampleProtocolUIView stop];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.sampleProtocolUIView start];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private
- (void)buildNewImageFromBufferForColourDetection:(UIImage*)bufferImage: didReadCode:(NSString*)decodedQRMessage{

    UIImage *testBuffer =bufferImage;
    NSString * testMessage =decodedQRMessage;
    
    

};
- (void) buildNewImageFromBufferForColourDetection: (UIImage*)bufferImage: (NSString*)decodedQRMessage{
    UIImage *testImage = bufferImage;
    NSLog(decodedQRMessage);
    NSLog(@"======================");
    
};



@end
