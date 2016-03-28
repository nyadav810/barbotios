//
//  Drink+CoreDataProperties.h
//  barbot
//
//  Created by Naveen Yadav on 3/23/16.
//  Copyright © 2016 BarBot. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Drink.h"

NS_ASSUME_NONNULL_BEGIN

@interface Drink (CoreDataProperties)

+ (NSString *) entityName;

+ (NSArray *)allDrinks:(NSManagedObjectContext *)moc;

@end

NS_ASSUME_NONNULL_END
