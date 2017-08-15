//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TTTableViewDataSource.h"
// - Table Items
#import "TTTableItem.h"
#import "TTTableTextItem.h"
#import "TTTableControlItem.h"
#import "TTTableCaptionItem.h"
#import "TTTableSubtextItem.h"
#import "TTButtonItem.h"
#import "UTPreferentialItem.h"
#import "UTStatusInfoItem.h"

// - Table Cells
#import "TTTableControlCell.h"
#import "TTTableTextItemCell.h"
#import "TTTableCaptionItemCell.h"
#import "TTTableSubtextItemCell.h"
#import "TTTableButtonCell.h"
#import "UTPreferentialItemCell.h"
#import "UTStatusInfoItemCell.h"

// Core
#import "TTCorePreprocessorMacros.h"

#import <objc/runtime.h>


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTTableViewDataSource

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {

  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSArray*)lettersForSectionsWithSearch:(BOOL)search summary:(BOOL)summary {
  NSMutableArray* titles = [NSMutableArray array];
  if (search) {
    [titles addObject:UITableViewIndexSearch];
  }

  for (unichar c = 'A'; c <= 'Z'; ++c) {
    NSString* letter = [NSString stringWithFormat:@"%c", c];
    [titles addObject:letter];
  }

  if (summary) {
    [titles addObject:@"#"];
  }

  return titles;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 0;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell*)tableView:(UITableView *)tableView
                    cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  id object = [self tableView:tableView objectForRowAtIndexPath:indexPath];

  Class cellClass = [self tableView:tableView cellClassForObject:object];
  const char* className = class_getName(cellClass);
  NSString* identifier = [[NSString alloc] initWithBytesNoCopy:(char*)className
                                           length:strlen(className)
                                           encoding:NSASCIIStringEncoding freeWhenDone:NO];

  UITableViewCell* cell =
    (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    cell = [[[cellClass alloc] initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:identifier] autorelease];
  }
  [identifier release];

  if ([cell isKindOfClass:[TTTableViewCell class]]) {
    [(TTTableViewCell*)cell setObject:object];
  }

  [self tableView:tableView cell:cell willAppearAtIndexPath:indexPath];

  return cell;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView {
  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView*)tableView sectionForSectionIndexTitle:(NSString*)title
            atIndex:(NSInteger)sectionIndex {
  if (tableView.tableHeaderView) {
    if (sectionIndex == 0)  {
      // This is a hack to get the table header to appear when the user touches the
      // first row in the section index.  By default, it shows the first row, which is
      // not usually what you want.
      [tableView scrollRectToVisible:tableView.tableHeaderView.bounds animated:NO];
      return -1;
    }
  }

  NSString* letter = [title substringToIndex:1];
  NSInteger sectionCount = [tableView numberOfSections];
  for (NSInteger i = 0; i < sectionCount; ++i) {
    NSString* section  = [tableView.dataSource tableView:tableView titleForHeaderInSection:i];
    if ([section hasPrefix:letter]) {
      return i;
    }
  }
  if (sectionIndex >= sectionCount) {
    return sectionCount-1;

  } else {
    return sectionIndex;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableView:(UITableView*)tableView objectForRowAtIndexPath:(NSIndexPath*)indexPath {
  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
    if ([object isKindOfClass:[TTTableItem class]]) {
        if ([object isKindOfClass:[TTTableSubtextItem class]]) {
            return [TTTableSubtextItemCell class];
        }else if ([object isKindOfClass:[TTButtonItem class]]) {
            return [TTTableButtonCell class];
        }else if ([object isKindOfClass:[TTTableCaptionItem class]]) {
            return [TTTableCaptionItemCell class];
        }else if ([object isKindOfClass:[TTTableControlItem class]]) {
            return [TTTableControlCell class];
        }else if ([object isKindOfClass:[UTStatusInfoItem class]]) {
            return [UTStatusInfoItemCell class];
        }
        else {
            return [TTTableTextItemCell class];
        }
    } else if ([object isKindOfClass:[UIControl class]]
             || [object isKindOfClass:[UITextView class]]
             /*|| [object isKindOfClass:[TTTextEditor class]]*/) {
        return [TTTableControlCell class];

    }
//  else if ([object isKindOfClass:[UIView class]]) {
//    return [TTTableFlushViewCell class];
//  }

  // This will display an empty white table cell - probably not what you want, but it
  // is better than crashing, which is what happens if you return nil here
    return [TTTableViewCell class];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)tableView:(UITableView*)tableView labelForObject:(id)object {
//  if ([object isKindOfClass:[TTTableTextItem class]]) {
//    TTTableTextItem* item = object;
//    return item.text;
//
//  } else {
    return [NSString stringWithFormat:@"%@", object];
//  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSIndexPath*)tableView:(UITableView*)tableView indexPathForObject:(id)object {
  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView*)tableView cell:(UITableViewCell*)cell
        willAppearAtIndexPath:(NSIndexPath*)indexPath {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableViewDidLoadModel:(UITableView*)tableView {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)search:(NSString*)text {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForLoading:(BOOL)reloading {
  if (reloading) {
    return @"Updating...";//TTLocalizedString(@"Updating...", @"");

  } else {
    return @"Loading...";//TTLocalizedString(@"Loading...", @"");
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)imageForEmpty {
  return [self imageForError:nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForEmpty {
  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForEmpty {
  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)reloadButtonForEmpty {
  return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)imageForError:(NSError*)error {
  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForError:(NSError*)error {
  return @"";//TTDescriptionForError(error);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForError:(NSError*)error {
  return @"Sorry, there was an error";//TTLocalizedString(@"Sorry, there was an error.", @"");
}


@end

