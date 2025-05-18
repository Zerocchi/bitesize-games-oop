pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
scorer=nil

function _init()

	plr1=plr:new()
	plr2=com:new()
	bl=ball:new()

	--sound
	if scorer==plr then
		sfx(plr.scored_sfx)
	elseif scorer==com then
		sfx(com.scored_sfx)
	else
		sfx(5)
	end
	
	scorer=nil
	
end

function _update60()
	bl:update()
	plr1:update()
	plr2:update(bl)
	
	-- collisions
	plr1:collided(bl)
	plr2:collided(bl)
	court:collided(bl)
	
	-- scoring
	scorer=court:winner(bl)
	if scorer!=nil then
		scorer.pts+=1
		_init()
	end
	
end

function _draw()
	cls()
	court:draw()
	bl:draw()
	plr1:draw()
	plr2:draw()
	
	print(plr.pts,30,2,plr.c)
	print(com.pts,95,2,com.c)
end
-->8
-- base class

class=setmetatable({
		new=function(self,tbl)
			tbl = tbl or {}
			setmetatable(tbl,{__index=self})
			return tbl
		end
},{__index=_ENV})

entity=class:new({
	x=0,
	y=0,
	sp=0
})
-->8
-- objects
plr=entity:new({
	c=12,
	w=2,
	h=10,
	spd=1,
	pts=0,
	scored_sfx=3,
	
	new=function(self)
		tbl = {}
		tbl.x=8
		tbl.y=63
		spd=1
		setmetatable(tbl,{__index=self})
		return tbl
	end,
	
	update=function(_ENV)
		if btn(⬆️) and y>court.t+1 then
			y-=spd
		end
		
		if btn(⬇️) and y+h<court.b-1 then
			y+=spd
		end
	end,
	
	draw=function(_ENV)
		rectfill(x,y,x+w,y+h,c)
	end,
	
	collided=function(_ENV,ball)
		if ball.dx<0
		and ball.x>=x
		and ball.x<=x+w
		and ball.y>=y
		and ball.y+ball.w<=y+h
		then
			
			--control ball dy if hit and press up or down
			if btn(⬆️) then
				if ball.dy>0 then --ball moves down
					ball.dy=-ball.dy
					ball.dy-=ball.spdup*2	
				else --ball moves up
					ball.dy-=ball.spdup*2
				end	
			end
			
			if btn(⬇️) then
				if ball.dy<0 then --ball moves up
					ball.dy=-ball.dy
					ball.dy+=ball.spdup*2
				else --ball moves down
					ball.dy+=ball.spdup*2
				end	
			end
			
			--flip ball dx and add speed
			ball.dx=-(ball.dx-ball.spdup)
			
			sfx(1)
			
		end
	end,
})

com=entity:new({
	c=8,
	w=2,
	h=10,
	spd=.75,
	pts=0,
	scored_sfx=4,
	
	new=function(self)
		tbl = {}
		tbl.x=117
		tbl.y=63
		spd=.75
		setmetatable(tbl,{__index=self})
		return tbl
	end,
	
	update=function(_ENV,ball)
		mid_com=y+(h/2)
		
		if ball.dx>0 then
			if mid_com>ball.y and y>court.t+1 then
				y-=spd
			end
			
			if mid_com<ball.y and y+h<court.b-1 then
				y+=spd
			end
			
		else
			if mid_com>73 then y-=spd end
			if mid_com<53 then y+=spd end
		end
	end,
	
	draw=function(_ENV)
		rectfill(x,y,x+w,y+h,c)
	end,
	
	collided=function(_ENV,ball)
		if ball.dx>0
		and ball.x+ball.w>=x
		and ball.x+ball.w<=x+w
		and ball.y>=y
		and ball.y+ball.w<y+h
		then
			ball.dx=-(ball.dx+ball.spdup)
			sfx(0)
		end
	end,
})

ball=entity:new({
	c=7,
	w=2,
	dx=.6,
	dy=flr(rnd(2))-.5,
	spd=1,
	spdup=.05,
	
	new=function(self)
		tbl = {}
		tbl.x=63
		tbl.y=63
		tbl.dx=.6
		tbl.dy=flr(rnd(2))-.5
		spd=1
		spdup=.05
		setmetatable(tbl,{__index=self})
		return tbl
	end,
	
	update=function(_ENV)
		x+=dx
		y+=dy
	end,
	
	draw=function(_ENV)
		rectfill(x,y,x+w,y+w,c)
	end
})

court=entity:new({
 --court
	l=0,
	r=127,
	t=10,
	b=127,
	
	-- center line
	linex=63,
	liney=10,
	linelength=4,
	
	draw=function(_ENV)
		rect(0,10,127,127,6)
		
		--dashed center line
		repeat
			line(linex,liney,linex,liney+linelength,5)
			liney += linelength*2
		until liney > b
		liney=10
	end,
	
	collided=function(_ENV,ball)
		if ball.y+ball.w>=b-1
		or ball.y<=t+1 then
			ball.dy=-ball.dy
			sfx(2)
		end
	end,
	
	winner=function(_ENV,ball)
		if ball.x>r then
			return plr
		end
		
		if ball.x<l then
			return com
		end
	end,
})
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00040000111501b1501e1500010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
000200000a0501a050220500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400000d0500a0500a0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000c05006030080200a0200a0100a01009010080600705007020080200a0200c0300d0300e030110300c030150401f0501f060000000000000000000000000000000000000000000000000000000000000
001000001e0502405027050250502405022040210401f0401d0401b0401904018030160301503013020110200c020090100401000000000000000000000000000000000000000000000000000000000000000000
0010000012050150501705019050190501a0501a0501a050190501905018050000001405000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
