//
//  BFPOverlayView.h
//  BattleFoodPorn
//
//  Created by Candance Smith on 7/18/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger , BFPOverlayViewMode) {
    BFPOverlayViewModeLeft,
    BFPOverlayViewModeRight
};

@interface BFPOverlayView : UIView

@property (nonatomic) BFPOverlayViewMode mode;
@property (nonatomic, strong) UIImageView *imageView;

@end
