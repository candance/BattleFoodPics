//
//  BFPDraggableViewBackground.m
//  BattleFoodPorn
//
//  Created by Candance Smith on 7/18/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import "BFPDraggableViewBackground.h"

@interface BFPDraggableViewBackground ()

@end

@implementation BFPDraggableViewBackground {
    
    NSInteger cardsLoadedIndex; //%%% the index of the card you have loaded into the loadedCards array last
    NSMutableArray *loadedCards; //%%% the array of card loaded (change max_buffer_size to increase or decrease the number of cards this holds)
//    
//    UIButton* menuButton;
//    UIButton* messageButton;
//    UIButton* foodPornButton;
//    UIButton* shittyFoodPornButton;
}

//this makes it so only two cards are loaded at a time to avoid performance and memory costs
static const int MAX_BUFFER_SIZE = 2; //%%% max number of cards loaded at any given time, must be greater than 1
static const float CARD_HEIGHT = 386; //%%% height of the draggable card
static const float CARD_WIDTH = 290; //%%% width of the draggable card

//%%% sets up the extra buttons on the screen
-(void)setupView
{
#warning customize all of this.  These are just place holders to make it look pretty
//    menuButton = [[UIButton alloc]initWithFrame:CGRectMake(17, 34, 22, 15)];
//    [menuButton setImage:[UIImage imageNamed:@"shitty"] forState:UIControlStateNormal];
////    messageButton = [[UIButton alloc]initWithFrame:CGRectMake(284, 34, 18, 18)];
////    [messageButton setImage:[UIImage imageNamed:@"notShitty"] forState:UIControlStateNormal];
//    shittyFoodPornButton = [[UIButton alloc]initWithFrame:CGRectMake(60, 485, 59, 59)];
//    [shittyFoodPornButton setImage:[UIImage imageNamed:@"shitty"] forState:UIControlStateNormal];
//    [shittyFoodPornButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
//    foodPornButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 485, 59, 59)];
//    [foodPornButton setImage:[UIImage imageNamed:@"notShitty"] forState:UIControlStateNormal];
//    [foodPornButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:menuButton];
////    [self addSubview:messageButton];
//    [self addSubview:shittyFoodPornButton];
//    [self addSubview:foodPornButton];
}

//%%% creates a card and returns it.
-(BFPDraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index {
    
    BFPDraggableView *draggableView = [[BFPDraggableView alloc]initWithFrame:CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)];
    
    draggableView.cardImageView.contentMode = UIViewContentModeScaleAspectFit;
    draggableView.cardImageView.image = [self.gameCards objectAtIndex:index].image;
    draggableView.delegate = self;
    return draggableView;
}

//%%% loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards {
    
    loadedCards = [[NSMutableArray alloc] init];
    self.allCards = [[NSMutableArray alloc] init];
    cardsLoadedIndex = 0;
    
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

#warning include own action here!
//%%% action called when the card goes to the left.
// This should be customized with your own action
-(void)cardSwipedLeft:(UIView *)card {
    
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [self.allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[self.allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
}

#warning include own action here!
//%%% action called when the card goes to the right.
// This should be customized with your own action
-(void)cardSwipedRight:(UIView *)card {
    
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    
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
