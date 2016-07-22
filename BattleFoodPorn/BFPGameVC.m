//
//  BFPGameVC.m
//  BattleFoodPorn
//
//  Created by Candance Smith on 7/18/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import "BFPGameVC.h"
#import "BFPDraggableViewBackground.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "BFPGameCard.h"
#import "BFPEndGameVC.h"

@interface BFPGameVC ()

@property (strong, nonatomic) NSArray *shittyFoodPornPhotosResults;
@property (strong, nonatomic) NSArray *foodPornPhotosResults;
@property (strong, nonatomic) NSMutableArray *gameCards;
@property (strong, nonatomic) IBOutlet BFPDraggableViewBackground *draggableBackgroundView;

@end

@implementation BFPGameVC

#define IMGUR_PHOTO_URL @"link"
#define IMGUR_SUBREDDIT @"section"

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getShittyFoodPorn];
    [self getFoodPorn];
    self.draggableBackgroundView.delegate = self;
}

- (void)getShittyFoodPorn {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"Client-ID 3b73e207093f0c4" forHTTPHeaderField:@"Authorization"];
    [manager GET:@"https://api.imgur.com/3/gallery/r/shittyfoodporn" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSDictionary *shittyFoodPornPhotosTopLevelResults = (NSDictionary *)responseObject;
        self.shittyFoodPornPhotosResults = [shittyFoodPornPhotosTopLevelResults objectForKey:@"data"];
//        NSLog(@"Shitty Photos Results:%@", self.shittyFoodPornPhotosResults);
        
        if (self.foodPornPhotosResults) {
            [self mergePhotosResultsAndGetGamePhotos];
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)getFoodPorn {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"Client-ID 3b73e207093f0c4" forHTTPHeaderField:@"Authorization"];
    [manager GET:@"https://api.imgur.com/3/gallery/r/foodporn" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSDictionary *shittyFoodPornPhotosTopLevelResults = (NSDictionary *)responseObject;
        self.foodPornPhotosResults = [shittyFoodPornPhotosTopLevelResults objectForKey:@"data"];
//        NSLog(@"Photos Results:%@", self.foodPornPhotosResults);
        
        if (self.shittyFoodPornPhotosResults) {
            [self mergePhotosResultsAndGetGamePhotos];
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)mergePhotosResultsAndGetGamePhotos {
    
    NSArray *mergedPhotosResults = [self.shittyFoodPornPhotosResults arrayByAddingObjectsFromArray:self.foodPornPhotosResults];
//    NSLog(@"Merged Photos Results:%@", self.mergedPhotosResults);
    
    [self getRandomPhotosFrom:mergedPhotosResults];
}

- (void)getRandomPhotosFrom:(NSArray *)photosArray {
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
    [self.view addSubview:spinner];
    [self.view bringSubviewToFront:spinner];
    spinner.hidesWhenStopped = YES;
    spinner.hidden = NO;
    
    [spinner startAnimating];
    
    NSMutableArray *pickedPhotos = [NSMutableArray new];
    
    int remaining = 20;
    
    if (photosArray.count >= remaining) {
        while (remaining > 0) {
            int count = (int)photosArray.count;
            id photo = photosArray[arc4random_uniform(count)];
            
            if (![pickedPhotos containsObject:photo]) {
                [pickedPhotos addObject:photo];
                remaining--;
            }
        }
    }
    
    NSArray *randomPhotosArray = [pickedPhotos copy];
    //    NSLog(@"Picked photos:%@", self.gamePhotosArray);
    
    for (NSString *photo in randomPhotosArray) {
        BFPGameCard *card = [[BFPGameCard alloc] init];
        card.imageURL = [photo valueForKeyPath:IMGUR_PHOTO_URL];
        NSString *subreddit = [photo valueForKeyPath:IMGUR_SUBREDDIT];
        if ([subreddit isEqualToString:@"shittyfoodporn"]) {
            card.isShitty = YES;
        } else {
            card.isShitty = NO;
        }
        NSURL *url = [NSURL URLWithString:card.imageURL];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFImageResponseSerializer serializer];
        [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            card.image = responseObject;
            [self.gameCards addObject:card];
            if (self.gameCards.count == 20) {
                self.draggableBackgroundView.gameCards = self.gameCards;
                [spinner stopAnimating];
                [self.draggableBackgroundView loadCards];
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}

- (NSMutableArray *)gameCards {
    if (!_gameCards) _gameCards = [[NSMutableArray alloc] init];
    
    return _gameCards;
}

- (void)gameEndedConfirmationForSegue {
    [self performSegueWithIdentifier:@"End Game Page" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"End Game Page"]) {
        BFPEndGameVC *vc = [segue destinationViewController];
        vc.finalScore = self.draggableBackgroundView.score;
        }
}

@end
