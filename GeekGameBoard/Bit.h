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
#import "GGBLayer.h"


@class Game, Player;
@protocol BitHolder;


/** Standard Z positions */
enum {
    kBoardZ = 0,
    kCardZ  = 2,
    kPieceZ = 3,
    
    kPickedUpZ = 20
};


/** A moveable item in a card/board game.
    Abstract superclass of Card and Piece. */
@interface Bit : GGBLayer
{
    @private
    int _restingZ;      // Original z position, saved while pickedUp
    CATransform3D _restingTransform;
#if !TARGET_OS_IPHONE
    float _restingShadowOpacity, _restingShadowRadius;
    CGSize _restingShadowOffset;
#endif
    BOOL _pickedUp;
    Player *_owner;     // Player that owns this Bit
    NSInteger _tag;
}

/** Conveniences for getting/setting the layer's scale and rotation */
@property CGFloat scale;
@property int rotation;         // in degrees! Positive = clockwise

/** "Picking up" a Bit makes it larger, translucent, and in front of everything else */
@property BOOL pickedUp;

/** Current holder (or nil) */
@property (readonly) id<BitHolder> holder;

/** Ownership of this Bit */
@property (assign) Player *owner;

/** Conveniences for owner.friendly, owner.unfriendly */
@property (readonly, getter=isFriendly)   BOOL friendly;
@property (readonly, getter=isUnfriendly) BOOL unfriendly;

/** An uninterpreted integer that the Game can use for its own purposes. */
@property NSInteger tag;

/** Removes this Bit while running a explosion/fade-out animation */
- (void) destroy;

@end
