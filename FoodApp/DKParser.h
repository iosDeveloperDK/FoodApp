//
//  DKParser.h
//  FoodApp
//
//  Created by Denis on 09.12.16.
//  Copyright © 2016 Denis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKOffer : NSObject

@property (nonatomic) NSString* offerURL;
@property (nonatomic) NSString* offerName;
@property (nonatomic) NSString* offerPrice;
@property (nonatomic) NSString* offerCategoryId;
@property (nonatomic) NSString* offerDescription;
@property (nonatomic) NSURL* offerPicture;
@property (nonatomic) NSString* offerWeight;

- (instancetype)initWhithDictinary:(NSDictionary*)dict;
@end

@interface DKCategory : NSObject

@property (nonatomic) NSString* categoryTitle;
@property (nonatomic) NSString* categoryID;
@property (nonatomic) NSArray* arrayOffers;

- (instancetype)initWhithDictinary:(NSDictionary*)dict;

@end
