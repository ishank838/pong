Ball=Class{}
function Ball:init(x,y,width,height)
	self.x=x
	self.y=y
	self.width=width
	self.height=height
	self.dy=math.random(2)==1 and -100 or 100
	self.dx=math.random(2)==1 and math.random(-80,-100) or math.random(80,100)
end
function Ball:reset()
	self.x=vlwidth/2-2
	self.y=vlheight/2-2
	self.dy=math.random(2)==1 and -100 or 100
	self.dx=math.random(2)==1 and math.random(-80,-100) or math.random(80,100)
end
function Ball:update(dt)
	self.x=self.x+self.dx*dt
	self.y=self.y+self.dy*dt
end
function Ball:collide(paddle)
	if self.x>paddle.x+paddle.width or self.x+self.width<paddle.x then
		return false
	end
	if self.y+self.height<paddle.y or self.y>paddle.y+paddle.height then
		return false
	end
	return true
end
function Ball:render()
	love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)
end