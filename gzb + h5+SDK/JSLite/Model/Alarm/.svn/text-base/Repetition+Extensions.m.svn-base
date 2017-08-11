//
//  Repetition+Extensions.m
//  Move alarm
//
//  Created by Daniel Sullivan on 10/25/13.
//

#import "NSDate+MADateExtensions.h"
#import "MADebugMacros.h"
#import "Repetition+Extensions.h"

@implementation Repetition (Extensions)

#pragma mark - Class methods
+ (NSString *)entityName
{
  return @"Repetition";
}

+ (instancetype)insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)moc
{
  return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                       inManagedObjectContext:moc];
}
+ (NSArray *)createRepitionsForDaysWithManagedObjectContext:(NSManagedObjectContext *)moc
{
  
  

  Repetition *repitionMonday = [Repetition insertNewObjectInManagedObjectContext:moc];
  repitionMonday.day = @"Monday";
  repitionMonday.sortValue = [NSNumber numberWithInt:0];
  
  Repetition *repitionTuesday = [Repetition insertNewObjectInManagedObjectContext:moc];
  repitionTuesday.day = @"Tuesday";
  repitionTuesday.sortValue = [NSNumber numberWithInt:1];
  
  Repetition *repitionWednesday = [Repetition insertNewObjectInManagedObjectContext:moc];
  repitionWednesday.day = @"Wednesday";
  repitionWednesday.sortValue = [NSNumber numberWithInt:2];
  
  Repetition *repitionThursday = [Repetition insertNewObjectInManagedObjectContext:moc];
  repitionThursday.day = @"Thursday";
  repitionThursday.sortValue = [NSNumber numberWithInt:3];
  
  Repetition *repitionFriday = [Repetition insertNewObjectInManagedObjectContext:moc];
  repitionFriday.day = @"Friday";
  repitionFriday.sortValue = [NSNumber numberWithInt:4];
  
  Repetition *repitionSaturday = [Repetition insertNewObjectInManagedObjectContext:moc];
  repitionSaturday.day = @"Saturday";
  repitionSaturday.sortValue = [NSNumber numberWithInt:5];
    
    Repetition *repitionSunday = [Repetition insertNewObjectInManagedObjectContext:moc];
    repitionSunday.day = @"Sunday";
    repitionSunday.sortValue = [NSNumber numberWithInt:6];

  return @[repitionMonday, repitionTuesday,repitionWednesday, repitionThursday, repitionFriday, repitionSaturday,repitionSunday];
}

+ (Repetition *) closestRepetitionFromToday:(NSArray *)repetitions
{
  Repetition *nextRepetition = nil;
  NSDate *today = [NSDate date];
  NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  gregorianCalendar.locale = [NSLocale currentLocale];
  
  NSDateComponents *components = [gregorianCalendar components:NSYearCalendarUnit |
                                  NSWeekCalendarUnit | NSHourCalendarUnit | NSWeekdayCalendarUnit |
                                  NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:today];
  
  MADayOfTheWeek dayOfTheWeek = components.weekday;
  
  for (Repetition *repetition in repetitions) {
    MADayOfTheWeek repetitionDay = [NSDate dayEnumFromString:repetition.day];
    if ([repetition.shouldRepeat boolValue] && dayOfTheWeek == repetitionDay) {
      nextRepetition = repetition;
      break;
    }
    else
    {
      continue;
    }
  }
  return nextRepetition;
}

+ (void) clearRepetitionsWithManagedObjectContext:(NSManagedObjectContext *)moc{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    NSError *error = nil;
    
    NSArray* result = [moc executeFetchRequest:request error:&error];
    for (id repetition in result) {
        [moc deleteObject:repetition];
    }
}

#pragma mark - Instance Methods
- (NSString *)displayName
{
  return [@"Every " stringByAppendingString:self.day];
}

- (MADayOfTheWeek)dayEnum
{
  return [NSDate dayEnumFromString:self.day];
}

@end
