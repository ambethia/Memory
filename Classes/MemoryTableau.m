//
//  MemoryTableau.m
//  Games
//
//  Created by Jason Perry on 2/13/10.
//  Copyright 2010 Ambethia. All rights reserved.
//

#import "MemoryTableau.h"
#import "MemoryCard.h"

@implementation MemoryTableau
@synthesize removedPairs = _removedPairs;

- (id) init {
  self = [super initWithRows: 4
                     columns: 4
                     spacing: CGSizeMake(kMemoryCardWidth+12,
                                         kMemoryCardHeight+12)
                    position: CGPointMake(13, 13)];
  if (self) {
    [self setLineColor:nil];
  }
  return self;
}

- (GridCell*) createCellAtRow: (unsigned)row
                       column: (unsigned)col 
               suggestedFrame: (CGRect)frame {
  MemoryTableauCell *cell = [[MemoryTableauCell alloc] initWithGrid: self 
                                                row: row column: col
                                              frame: CGRectMake(frame.origin.x,
                                                                frame.origin.y,
                                                                kMemoryCardWidth,
                                                                kMemoryCardHeight)];
  [cell setName:[NSString stringWithFormat: @"%c%u", ('A'+row),(1+col)]];
  return [cell autorelease];
}

- (NSArray*) shownCards {
  NSMutableArray *cards = [NSMutableArray arrayWithCapacity:2];
  for (MemoryTableauCell *cell in [self cells]) {
    if ([(MemoryCard*)[cell bit] faceUp]) {
      [cards addObject:[cell bit]];
    }
  }
  return cards;
}

- (BOOL) checkMatchedPairs {
  if ([[[self shownCards] objectAtIndex:0] pairId] ==
      [[[self shownCards] objectAtIndex:1] pairId]) {
    _removedPairs++;
    [self performSelector:@selector(removeShownCards)
               withObject:nil
              afterDelay:0.33];
    return YES;
  }
  return NO;
}

- (void) resetCards {
  for (MemoryCard* card in [self shownCards]) {
    [card setFaceUp:NO];
  }  
}

- (void) removeShownCards {
  for (MemoryCard* card in [self shownCards]) {
    [card destroy];
  }  
}


@end

@implementation MemoryTableauCell

- (Bit*) canDragBit: (Bit*)bit {
  return nil;
}

@end
