//
//  ViewController.m
//  LEHaloView
//
//  Created by 陈记权 on 8/4/16.
//  Copyright © 2016 LeEco. All rights reserved.
//

#import "ViewController.h"
#import "LEHaloView.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet LEHaloView *haloView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_haloView.isAnimating) {
        [_haloView stopHalo];
    } else {
        [_haloView startHalo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
