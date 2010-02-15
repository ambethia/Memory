/*  This code is based on Apple's "GeekGameBoard" sample code, version 1.0.
    http://developer.apple.com/samplecode/GeekGameBoard/
    Copyright © 2007 Apple Inc. Copyright © 2008 Jens Alfke. All Rights Reserved.

    Redistribution and use in source and binary forms, with or without modification, are permitted
    provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions
      and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of
      conditions and the following disclaimer in the documentation and/or other materials provided
      with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
    IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND 
    FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRI-
    BUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
    PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
    THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import <Foundation/Foundation.h>
@class GGBLayer, Bit, BitHolder, Player, Turn;
@protocol BitHolder;


/** Abstract superclass. Keeps track of the rules and turns of a game. */
@interface Game : NSObject <NSCoding>
{
    GGBLayer *_table;
    NSArray *_players;
    Player *_winner;
    NSMutableArray *_turns;
    unsigned _currentTurnNo;
    NSMutableDictionary *_extraValues;
    BOOL _requireConfirmation;
    CGFloat _tablePerspectiveAngle;
}

#pragma mark  Class properties:

/** The name used to identify this class of game in URLs.
    (By default it just returns the class name with the "Game" suffix removed.) */
+ (NSString*) identifier;

/** The human-readable name of this class of game.
    (By default it just returns the class name with the "Game" suffix removed.) */
+ (NSString*) displayName;

/** Is this game's board wider than it's high? */
+ (BOOL) landscapeOriented;


/** Designated initializer: override this if your subclass needs additional initialization. */
- (id) init;

/** Convenience initializer that calls -init, -setTable:, and -nextTurn. */
- (id) initNewGameWithTable: (GGBLayer*)table;

/** NSCoding initializer. Calls -init, but then restores saved payers, states, moves. */
- (id) initWithCoder: (NSCoder*)decoder;

/** NSCoding method to save Game to an archive. */
- (void) encodeWithCoder: (NSCoder*)coder;


@property (readonly, copy) NSArray *players;
@property (readonly) Player *currentPlayer, *winner, *remotePlayer;
@property (readonly, getter=isLocal) BOOL local;            // Are all players local?

@property (retain) GGBLayer *table;                         // The root layer for the game.

@property (readonly) NSArray *turns;
@property (readonly) Turn *currentTurn, *latestTurn;
@property (readonly) unsigned maxTurnNo;
@property unsigned currentTurnNo;
@property (readonly) BOOL isLatestTurn;

/** Check this before the user begins a move action (mouse-down on a bit, etc.)
    It's YES if it's OK to move,  or NO if the current move is finished or it's another player's turn. */
@property (readonly) BOOL okToMove;

@property BOOL requireConfirmation;
- (void) cancelCurrentTurn;
- (void) confirmCurrentTurn;


#pragma mark  Methods for subclasses to implement:

/** An icon for a player (usually the same as the image of the player's pieces.) */
- (CGImageRef) iconForPlayer: (int)playerIndex;


/** Should return YES if it is legal for the given bit to be moved from its current holder.
    Default implementation always returns YES. */
- (BOOL) canBit: (Bit*)bit moveFrom: (id<BitHolder>)src;

/** Should return YES if it is legal for the given Bit to move from src to dst.
    Default implementation always returns YES. */
- (BOOL) canBit: (Bit*)bit moveFrom: (id<BitHolder>)src to: (id<BitHolder>)dst;


/** Should handle any side effects of a Bit's movement, such as captures or scoring.
    Does not need to do the actual movement! That's already happened.
    It should end by calling -endTurn, if the player's turn is over.
    Default implementation just calls -endTurn. */
- (void) bit: (Bit*)bit movedFrom: (id<BitHolder>)src to: (id<BitHolder>)dst;

/** Called on mouse-down/touch of an *empty* BitHolder. Should return a Bit if
    it's OK to place a new Bit there; else nil. */
- (Bit*) bitToPlaceInHolder: (id<BitHolder>)holder;

/** Called instead of the above if a Bit is simply clicked, not dragged.
    Should return NO if the click is illegal (i.e. clicking an empty draw pile in a card game.)
    Default implementation always returns YES. */
- (BOOL) clickedBit: (Bit*)bit;

@end
