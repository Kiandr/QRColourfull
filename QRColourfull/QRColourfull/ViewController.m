//
//  ViewController.m
//  QRColourfull
//
//  Created by Kian Davoudi-Rad on 2016-05-24.
//  Copyright © 2016 Kian Davoudi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[UIAccelerometer sharedAccelerometer]setDelegate:self];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAccelerometer protocol delegate
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:
(UIAcceleration *)acceleration{
    [_xlabel setText:[NSString stringWithFormat:@"%f",acceleration.x]];
    [_ylabel setText:[NSString stringWithFormat:@"%f",acceleration.y]];
    [_zlabel setText:[NSString stringWithFormat:@"%f",acceleration.z]];
}

@end
