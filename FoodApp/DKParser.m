//
//  DKParser.m
//  FoodApp
//
//  Created by Denis on 09.12.16.
//  Copyright © 2016 Denis. All rights reserved.
//

#import "DKParser.h"

@implementation DKCategory


- (instancetype)initWhithDictinary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        
        if (dict) {
            
            self.categoryID = [dict objectForKey:@"categoryID"];
            self.categoryTitle = [dict objectForKey:@"categoryTitle"];
            
        }
        
    }
    return self;
}

@end

@implementation DKOffer


- (instancetype)initWhithDictinary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        
        if (dict) {
            
            self.offerURL = [dict objectForKey:@"offerURL"];
            self.offerName = [dict objectForKey:@"offerName"];
            self.offerPrice = [dict objectForKey:@"offerPrice"];
            self.offerCategoryId = [dict objectForKey:@"offerCategoryId"];
            self.offerDescription = [dict objectForKey:@"offerDescription"];
            self.offerPicture = [NSURL URLWithString:[dict objectForKey:@"offerPicture"]];
            self.offerWeight = [dict objectForKey:@"offerWeight"];
            
        }
        
    }
    return self;
}

@end
