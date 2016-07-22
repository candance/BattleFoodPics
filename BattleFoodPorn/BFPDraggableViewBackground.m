//
//  BFPDraggableViewBackground.m
//  BattleFoodPorn
//
//  Created by Candance Smith on 7/18/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import "BFPDraggableViewBackground.h"
#import "BFPGameCard.h"
#import "BFPGameVC.h"

@interface BFPDraggableViewBackground ()

@property (strong, nonatomic) BFPGameVC *game;
@property (strong, nonatomic) BFPGameCard *gameCard;
@property (nonatomic) NSInteger scoreGained;
@property (nonatomic, readwrite) NSInteger score;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *shittyFoodPornButton;
@property (weak, nonatomic) IBOutlet UIButton *foodPornButton;


@end

@implementation BFPDraggableViewBackground {
    
    NSInteger cardsLoadedIndex; //%%% the index of the card you have loaded into the loadedCards array last
    NSMutableArray *loadedCards; //%%% the array of card loaded (change max_buffer_size to increase or decrease the number of cards this holds)
}

//this makes it so only two cards are loaded at a time to avoid performance and memory costs
static const int MAX_BUFFER_SIZE = 2; //%%% max number of cards loaded at any given time, must be greater than 1
static const float CARD_HEIGHT = 386; //%%% height of the draggable card
static const float CARD_WIDTH = 290; //%%% width of the draggable card

//%%% sets up the extra buttons on the screen
-(void)setupView
{
//    self.backgroundColor = [UIColor colorWithRed:0.75 green:1.00 blue:0.71 alpha:1.0];
    
    //    [menuButton setImage:[UIImage imageNamed:@"shitty"] forState:UIControlStateNormal];

//    [shittyFoodPornButton setImage:[UIImage imageNamed:@"shitty"] forState:UIControlStateNormal];
    [self.shittyFoodPornButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
    
//    [foodPornButton setImage:[UIImage imageNamed:@"notShitty"] forState:UIControlStateNormal];
    [self.foodPornButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
}

//%%% creates a card and returns it.
-(BFPDraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index {
    
    BFPDraggableView *draggableView = [[BFPDraggableView alloc]initWithFrame:CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)];
    
    draggableView.cardImageView.contentMode = UIViewContentModeScaleAspectFit;
    draggableView.cardImageView.image = [self.gameCards objectAtIndex:index].image;
    draggableView.isShitty = [self.gameCards objectAtIndex:index].isShitty;
    draggableView.delegate = self;
    return draggableView;
}

//%%% loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards {
    
    [self setupView];
    
    loadedCards = [[NSMutableArray alloc] init];
    self.allCards = [[NSMutableArray alloc] init];
    cardsLoadedIndex = 0;
    self.score = 0;
    
    if (self.gameCards.count > 0) {
        
        NSInteger numLoadedCardsCap =((self.gameCards.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE:self.gameCards.count);
        //%%% if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen
        
        for (int i = 0; i < self.gameCards.count; i++) {
            
            BFPDraggableView *newCard = [self createDraggableViewWithDataAtIndex:i];
            [self.allCards addObject:newCard];
            
            if (i < numLoadedCardsCap) {
                //%%% adds a small number of cards to be loaded
                [loadedCards addObject:newCard];
            }
        }
        
        //%%% displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
        // are showing at once and clogging a ton of data
        for (int i = 0; i < [loadedCards count]; i++) {
            if (i > 0) {
                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
            } else {
                [self addSubview:[loadedCards objectAtIndex:i]];
            }
            cardsLoadedIndex++; //%%% we loaded a card into loaded cards, so we have to increment
        }
    }
}

- (void)checkIfGameHasEnded {
    if (!loadedCards.count) {
        NSLog(@"Game Finishes");
        [self.delegate gameEndedConfirmationForSegue];
    }
}

//%%% action called when the card goes to the left.
-(void)cardSwipedLeft:(UIView *)card {
    
    //do whatever you want with the card that was swiped
    BFPDraggableView *c = (BFPDraggableView *)card;
    
    if (c.isShitty) {
        self.scoreGained = 10;
    }
    else {
        self.scoreGained = -5;
    }
    
    self.score += self.scoreGained;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", self.score];
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [self.allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[self.allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
}

//%%% action called when the card goes to the right.
-(void)cardSwipedRight:(UIView *)card {
    
    //do whatever you want with the card that was swiped
    BFPDraggableView *c = (BFPDraggableView *)card;

    if (c.isShitty) {
        self.scoreGained = -5;
    }
    else {
        self.scoreGained = 10;
    }
    
    self.score += self.scoreGained;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", self.score];
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [self.allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[self.allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
}

//%%% when you hit the right button, this is called and substitutes the swipe
-(void)swipeRight {
    
    BFPDraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = BFPOverlayViewModeRight;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView rightClickAction];
}

//%%% when you hit the left button, this is called and substitutes the swipe
-(void)swipeLeft {
    
    BFPDraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = BFPOverlayViewModeLeft;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView leftClickAction];
}

@end
