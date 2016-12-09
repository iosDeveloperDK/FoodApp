//
//  DKServerManager.m
//  FoodApp
//
//  Created by Denis on 09.12.16.
//  Copyright © 2016 Denis. All rights reserved.
//

#import "DKDataManager.h"
#import "AFNetworking.h"
#import "DKParser.h"

@interface DKDataManager () <NSXMLParserDelegate>

{
    NSXMLParser * xmlParser;
    NSString * currentElement;
    NSDictionary * currentAttributeDict;
    NSMutableArray* arrayOffer;
    NSMutableArray* arrayCategory;

    NSString* categoryTitle;
    NSString* categoryID;

    NSString* offerURL;
    NSString* offerName;
    NSString* offerPrice;
    NSString* offerCategoryId;
    NSString* offerDescription;
    NSString* offerPicture;
    NSString* offerWeight;

    
}

@end

@implementation DKDataManager


+(DKDataManager*) sharedManager {
    
    static DKDataManager* manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[DKDataManager alloc]init];
        
    });
    
    return manager;
}

-(void)createXMLParserWhithURL:(NSURL*)url {

    
    self.arrayData = [NSMutableArray new];
    
    arrayCategory = [NSMutableArray new];
    
    arrayOffer = [NSMutableArray new];
    
    self.isParse = YES;
    
    xmlParser = [[NSXMLParser alloc]initWithContentsOfURL:url];
    
    xmlParser.delegate = self;

    [xmlParser parse];

    
}



- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {

    currentElement = elementName;
    
    currentAttributeDict = attributeDict;
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

    
    
    if ([elementName isEqualToString:@"category"]) {
        
        DKCategory* category = [[DKCategory alloc]initWhithDictinary:@{@"categoryID":categoryID,@"categoryTitle":categoryTitle}];
        
        [arrayCategory addObject:category];
        
    }
    
    if ([elementName isEqualToString:@"offer"]){

        //Данные на сайте меняються(пару раз удаляли картинки и вес) поэтому инициализация через дикшинари без кучи проверок не имеет смысла
        
//             DKOffer* offer = [[DKOffer alloc]initWhithDictinary:@{@"offerName":offerName,@"offerPrice":offerPrice,@"offerPicture":offerPicture,@"offerDescription":offerDescription,@"offerCategoryId":offerCategoryId,@"offerWeight":offerWeight}];
        
            DKOffer* offer = [DKOffer new];
            offer.offerName = offerName;
            offer.offerPrice = offerPrice;
            offer.offerPicture = [NSURL URLWithString:offerPicture];
            offer.offerDescription = offerDescription;
            offer.offerCategoryId = offerCategoryId;
            offer.offerWeight = offerWeight;
        
            [arrayOffer addObject:offer];

       
        
    }
    
    currentElement = nil;

}

- (void)parserDidEndDocument:(NSXMLParser *)parser {

    for (DKCategory* category in arrayCategory) {
        
        @autoreleasepool {
            
        NSMutableArray* arrayOffers = [NSMutableArray new];
        
        for (DKOffer* offer in arrayOffer) {
            
            if ([category.categoryID isEqual:offer.offerCategoryId]) {
                
                [arrayOffers addObject:offer];
                
            }
            
        }
        
        DKCategory* data = category;
        
        data.arrayOffers = arrayOffers.copy;
        
        [self.arrayData addObject:data];
        
        }
        
    }
    
}

- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string{

    
    if ([currentElement isEqualToString:@"category"]) {

        categoryID = [currentAttributeDict objectForKey:@"id"];
        
        categoryTitle = string;

    }
    
    if ([currentElement isEqualToString:@"name"])
    {
        
        offerName = string;
    }
    else if ([currentElement isEqualToString:@"price"])
    {
        offerPrice = string;
    }
    else if ([currentElement isEqualToString:@"description"])
    {
        offerDescription = string;
    }
    else if ([currentElement isEqualToString:@"picture"])
    {
        offerPicture = string;
    }
    else if ([currentElement isEqualToString:@"categoryId"])
    {
        offerCategoryId = string;
    }
    else if ([currentElement isEqualToString:@"param"])
    {
        
        if ([[currentAttributeDict objectForKey:@"name"] isEqualToString:@"Вес"]) {
            
            if (![string isEqualToString:@"гр"]) {
                
                offerWeight = [string stringByAppendingString:@"гр"];

                
            }
        }
        
    }
   
    

}
@end
