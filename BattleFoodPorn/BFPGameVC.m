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

@interface BFPGameVC ()

@property (strong, nonatomic) NSArray *shittyFoodPornPhotosResults;
@property (strong, nonatomic) NSArray *foodPornPhotosResults;
@property (strong, nonatomic) NSArray *mergedPhotosResults;
@property (strong, nonatomic) NSArray *randomPhotosArray;
@property (strong, nonatomic) NSArray *randomPhotosURL;

@end

@implementation BFPGameVC

#define IMGUR_PHOTO_URL @"link"
#define IMGUR_SUBREDDIT @"section"

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getShittyFoodPorn];
    [self getFoodPorn];
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
    
    self.mergedPhotosResults = [self.shittyFoodPornPhotosResults arrayByAddingObjectsFromArray:self.foodPornPhotosResults];
//    NSLog(@"Merged Photos Results:%@", self.mergedPhotosResults);
    
    [self getRandomPhotosFrom:self.mergedPhotosResults];
    [self downloadPhotosFrom:self.randomPhotosArray];
}

- (NSArray *)getRandomPhotosFrom:(NSArray *)photosArray {
    
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
    
    self.randomPhotosArray = [pickedPhotos copy];
//    NSLog(@"Picked photos:%@", self.gamePhotosArray);
    
    return self.randomPhotosArray;
}

- (void)downloadPhotosFrom:(NSArray *)randomPhotosArray {
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
    [self.view addSubview:spinner];
    [self.view bringSubviewToFront:spinner];
    spinner.hidesWhenStopped = YES;
    spinner.hidden = NO;
    
    [spinner startAnimating];
    
    self.photoSubreddit = [randomPhotosArray valueForKeyPath:IMGUR_SUBREDDIT];
//    NSLog(@"Subreddit: %@", self.photoSubreddit);
    
    self.randomPhotosURL = [randomPhotosArray valueForKeyPath:IMGUR_PHOTO_URL];
//    NSLog(@"URL: %@", self.randomPhotosURL);
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:self.randomPhotosURL.count];
    
    for (int i = 0; i < self.randomPhotosURL.count; i++) {
        [photos addObject:[NSNull null]];
    }
    for (int i = 0; i < self.randomPhotosURL.count; i++) {
        NSURL *url = [NSURL URLWithString:self.randomPhotosURL[i]];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFImageResponseSerializer serializer];
        [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            UIImage *photo = responseObject;
            [photos replaceObjectAtIndex:i withObject:photo];
            
            // make sure all photos have been downloaded before passing it to gamePhotos
            if (![photos containsObject:[NSNull null]]) {
                self.gamePhotos = [photos copy];
//                NSLog(@"Downloaded photos:%@", self.gamePhotos);
            }
            
            if (self.gamePhotos) {
                [spinner stopAnimating];
                BFPDraggableViewBackground *draggableBackground = [[BFPDraggableViewBackground alloc]initWithFrame:self.view.frame];
                draggableBackground.gameCardPhotos = self.gamePhotos;
                NSLog(@"Example: %@", draggableBackground.gameCardPhotos);
                
//                [self.view addSubview:draggableBackground];
            }
            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}

@end
