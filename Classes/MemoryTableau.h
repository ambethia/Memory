//
//  MemoryTableau.h
//  Games
//
//  Created by Jason Perry on 2/13/10.
//  Copyright 2010 Ambethia. All rights reserved.
//

#import "Grid.h"

@interface MemoryTableau : Grid {
  int _removedPairs;
}
@property (readonly) int removedPairs;
- (NSArray*) shownCards;
- (BOOL) checkMatchedPairs;
- (void) removeShownCards;
- (void) resetCards;
@end

@interface MemoryTableauCell : GridCell {
  
}

@end
