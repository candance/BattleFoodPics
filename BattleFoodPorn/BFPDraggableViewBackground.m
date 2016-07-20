//
//  BFPDraggableViewBackground.m
//  BattleFoodPorn
//
//  Created by Candance Smith on 7/18/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import "BFPDraggableViewBackground.h"
#import "BFPGameVC.h"

@interface BFPDraggableViewBackground ()

@property (strong, nonatomic) BFPGameVC *gameVC;

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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [super layoutSubviews];
//        [self setupView];
        loadedCards = [[NSMutableArray alloc] init];
        self.allCards = [[NSMutableArray alloc] init];
        cardsLoadedIndex = 0;
        [self loadCards];
    }
    return self;
}

//%%% sets up the extra buttons on the screen
-(void)setupView
{
#warning customize all of this.  These are just place holders to make it look pretty
//    self.backgroundColor = [UIColor colorWithRed:.93 green:.00 blue:1.00 alpha:1]; // purple
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

#warning include own card customization here!
//%%% creates a card and returns it.  This should be customized to fit your needs.
// use "index" to indicate where the information should be pulled.  If this doesn't apply to you, feel free
// to get rid of it (eg: if you are building cards from data from the internet)
-(BFPDraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index {
    
    BFPDraggableView *draggableView = [[BFPDraggableView alloc]initWithFrame:CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)];
    draggableView.cardImageView.image = [self.gameCardPhotos objectAtIndex:index];
    draggableView.delegate = self;
    return draggableView;
    
}

//%%% loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards {
    
    if([self.gameCardPhotos count] > 0) {
        NSInteger numLoadedCardsCap =(([self.gameCardPhotos count] > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE:[self.gameCardPhotos count]);
        //%%% if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen
        
        //%%% loops through the exampleCardsLabels array to create a card for each label.  This should be customized by removing "exampleCardLabels" with your own array of data
        for (int i = 0; i < [self.gameCardPhotos count]; i++) {
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
