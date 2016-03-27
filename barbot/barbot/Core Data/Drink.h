//
//  Drink.h
//  barbot
//
//  Created by Naveen Yadav on 3/23/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Drink+CoreDataProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface Drink : NSManagedObject

@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END


