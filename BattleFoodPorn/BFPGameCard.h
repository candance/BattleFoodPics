//
//  BFPgameCards.h
//  BattleFoodPorn
//
//  Created by Candance Smith on 7/21/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BFPGameCard : NSObject

@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic) BOOL isShitty;

@end
