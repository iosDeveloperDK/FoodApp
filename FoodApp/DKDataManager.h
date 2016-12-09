//
//  DKServerManager.h
//  FoodApp
//
//  Created by Denis on 09.12.16.
//  Copyright © 2016 Denis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKDataManager : NSObject

@property (nonatomic) BOOL isParse;

@property (nonatomic) NSMutableArray* arrayData;

+(DKDataManager*) sharedManager;

//получение данных с указанного урл

-(void)createXMLParserWhithURL:(NSURL*)url;

@end
