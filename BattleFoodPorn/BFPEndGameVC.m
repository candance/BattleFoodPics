//
//  BFPEndGameVC.m
//  BattleFoodPorn
//
//  Created by Candance Smith on 7/21/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import "BFPEndGameVC.h"
#import "BFPDraggableViewBackground.h"

@interface BFPEndGameVC ()

@property (weak, nonatomic) IBOutlet UILabel *finalScoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *replayButton;

@end

@implementation BFPEndGameVC

-(void)viewDidLoad {
    [super viewDidLoad];
    self.finalScoreLabel.text = [NSString stringWithFormat:@"%ld", self.finalScore];
}

- (IBAction)replayButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"Replay Game" sender:sender];
}

@end
