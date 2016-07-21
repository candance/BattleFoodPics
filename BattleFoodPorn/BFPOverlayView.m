//
//  BFPOverlayView.m
//  BattleFoodPorn
//
//  Created by Candance Smith on 7/18/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import "BFPOverlayView.h"

@implementation BFPOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shittyFoodPornButton"]];
        [self addSubview:self.imageView];
    }
    return self;
}

-(void)setMode:(BFPOverlayViewMode)mode
{
    if (_mode == mode) {
        return;
    }
    
    _mode = mode;
    
    if(mode == BFPOverlayViewModeLeft) {
        self.imageView.image = [UIImage imageNamed:@"shittyFoodPornButton"];
    } else {
        self.imageView.image = [UIImage imageNamed:@"foodPornButton"];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(100, 50, 100, 100);
}

@end
