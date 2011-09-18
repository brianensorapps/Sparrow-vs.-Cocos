//
//  Coco.m
//  Sparrow vs. Cocos
//
//  Created by Arend Hintze on 17.09.11.
//  Copyright 2011 KGI. All rights reserved.
//

#import "Coco.h"


@implementation Coco

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(id) initWithPosition:(SPPoint*)startPosition targetPosition:(SPPoint*)targetPosition inMap:(Map*)map{
    //this constructor expects a start position in tile map coordinates not in absolute coordinates
    self = [super init];
    if (self) {
        animationJuggler=[[SPJuggler alloc] init];
        //This is the preiminary graphic...
        M = [[SPMovieClip alloc] initWithFrame:[SPTexture textureWithContentsOfFile:@"body000.png"] fps:20.0];
        [M play];
        [animationJuggler addObject:M];
        [self addChild:M];
        self.pivotX=M.width/2.0;
        self.pivotY=M.height/2.0;
        angle=0.0;
        speed=10.0;
        currentMapPosition=startPosition;
        self.x=currentMapPosition.x*32-(map.width/2);
        self.y=currentMapPosition.y*32-(map.height/2);
        [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
        [self setNewTarget:targetPosition inMap:map];
    }    
    return self;
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event {
    float passedTime=event.passedTime;
    float targetAngle,dx,dy;
    [animationJuggler advanceTime:passedTime];
    //move the cocos
    self.x+=sin(angle)*speed*passedTime;
    self.y+=cos(angle)*speed*passedTime;
    dx=target.x-self.x;
    dy=target.y-self.y;
    targetAngle=atan2(dy,dx);
    if(targetAngle>angle+(PI/12))
        angle+=PI/12;
    if(targetAngle<angle+(PI/12))
        angle-=PI/12;
    self.rotation=angle;
}

-(void) setNewTarget:(SPPoint*)newTarget inMap:(Map*)map{ 
    int xm[4]={0,1,0,-1};
    int ym[4]={-1,0,1,0};
    waypointStack=[[NSMutableArray alloc] init];
    target=newTarget;
    NSMutableArray *A=map.collisionMap;
    NSMutableArray *adds,*news;
    int currentDist=2;
    //instead of making a dynamic array I simply assume that there will never be a level bigger then 200x200
    int dist[200][200];
    int x,y,i,j;
    for(x=0;x<[A count];x++)
        for(y=0;y<[[A objectAtIndex:x] count];y++)
            dist[x][y]=[[[A objectAtIndex:x] objectAtIndex:y] intValue];
    adds=[[NSMutableArray alloc] init];
    [adds addObject:newTarget];
    dist[(int)newTarget.x][(int)newTarget.y]=currentDist;
    while([adds count]!=0){
        currentDist++;
        news=[[NSMutableArray alloc] init];
        for(SPPoint *P in adds){
            for(i=0;i<4;i++)
                if(dist[(int)P.x+xm[i]][(int)P.y+ym[i]]==0){
                    dist[(int)P.x+xm[i]][(int)P.y+ym[i]]=currentDist;
                    [news addObject:[[SPPoint alloc] initWithX:P.x+xm[i] y:P.y+ym[i]]];
                }
        }
        adds=news;
    }
    for(x=0;x<[A count];x++)
        for(y=0;y<[[A objectAtIndex:x] count];y++)
            if(dist[x][y]==1)
                dist[x][y]=currentDist+1;
    currentDist=dist[(int)currentMapPosition.x][(int)currentMapPosition.y];
    x=currentMapPosition.x;
    y=currentMapPosition.y;
    while(currentDist!=2){
        j=0;
        for(i=1;i<4;i++)
            if((dist[x+xm[i]][y+ym[i]]!=1)&&(dist[x+xm[i]][y+ym[i]]<dist[x+xm[j]][y+ym[j]]))
                j=i;
        [waypointStack addObject:[[SPPoint alloc] initWithX:x+xm[j] y:y+ym[j]]];
        x+=xm[j];
        y+=ym[j];
        currentDist=dist[x][y];
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
