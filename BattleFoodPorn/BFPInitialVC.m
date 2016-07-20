//
//  BFPInitialVC.m
//  BattleFoodPorn
//
//  Created by Candance Smith on 7/18/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import "BFPInitialVC.h"

@interface BFPInitialVC ()

@property (weak, nonatomic) IBOutlet UIButton *startGameButton;

@end

@implementation BFPInitialVC

- (IBAction)startGameButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"Start Game" sender:sender];
}

@end
