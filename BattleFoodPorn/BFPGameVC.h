//
//  BFPGameVC.h
//  BattleFoodPorn
//
//  Created by Candance Smith on 7/18/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFPDraggableViewBackground.h"

@interface BFPGameVC : UIViewController <DraggableViewBackgroundDelegate>

- (void)gameEndedConfirmationForSegue;

@end
