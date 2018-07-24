push=require 'push'
Class= require 'Class'
require'Paddle'
require 'Ball'
windowwidth=1280
windowheight=720
vlwidth=432
vlheight=243
paddle_speed=200
servinglayer=1
winingplayer=0
function love.load()
	love.graphics.setDefaultFilter("nearest","nearest")
	smallfont=love.graphics.newFont("font.ttf",8)
	medfont=love.graphics.newFont("font.ttf",16)
	largefont=love.graphics.newFont("font.ttf",32)
	love.window.setTitle("Pong")
	math.randomseed(os.time())
	push:setupScreen(vlwidth,vlheight,windowwidth,windowheight,
	{
	fullscreen=false,
	vsync=true,
	resizable=false
	})
	player1Score=0
	player2Score=0
	player1=Paddle(0,50,5,20)
	player2=Paddle(vlwidth-5,50,5,20)
	ball=Ball(vlwidth/2-2,vlheight/2-2,4,4)
	audio={['win']=love.audio.newSource('audio/win.wav','static'),
	['collide']=love.audio.newSource('audio/collide.wav','static'),
	['score']=love.audio.newSource('audio/score.wav','static')
	}
	gamestate='start'
end
function love.draw()
	push:apply('start')
	love.graphics.clear(0.5,0.5,0.67,1)
	love.graphics.setFont(smallfont)
    love.graphics.printf('Hello '..tostring(gamestate) ..'State!', 0, 20, vlwidth, 'center')
	love.graphics.setFont(largefont)
	love.graphics.printf(player1Score,0,vlheight/2,vlwidth/2-5,'right')
	love.graphics.printf(player2Score,vlwidth/2+5,vlheight/2,vlwidth/2,'left')
	love.graphics.setFont(medfont)
	if gamestate=='serve' then
		love.graphics.printf("Serving:"..tostring(servinglayer),0,vlheight/3,vlwidth,'center')
	elseif gamestate=='done' then
		love.graphics.printf("WINNER:"..tostring(winingplayer),0,vlheight/3,vlwidth,'center')
	end
	player1:render()
	player2:render()
	ball:render()
	displayFPS()
	push:apply('end')
end
function displayFPS()
    love.graphics.setFont(smallfont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
function love.keypressed(key)
	if key=='escape' then
		love.event.quit()
	elseif key=='enter' or key=='return' then
		if gamestate=='start' then
			gamestate='serve'
		elseif gamestate=='serve' then
			gamestate='play'
		elseif gamestate=='done' then
			gamestate='start'
			ball:reset()
			player2Score=0
			player1Score=0
		end
	end
end
function love.update(dt)
	if gamestate=='serve' then
		ball.dy=math.random(-50,50)
		if servinglayer==1 then
			ball.dx=math.random(60,140)
		else
			ball.dx=-math.random(60,140)
		end
	elseif gamestate=='play' then
		if ball:collide(player1) then
			ball.x=player1.x+5
			ball.dx=-ball.dx*1.03
			if ball.dy<0 then
				ball.dy=-math.random(30,150)
			else
				ball.dy=math.random(30,150)
			end
			audio['collide']:play()
		end
		if ball:collide(player2) then
			ball.x=player2.x-4
			ball.dx=-ball.dx*1.03
			if ball.dy<0 then
				ball.dy=-math.random(30,150)
			else
				ball.dy=math.random(30,150)
			end
			audio['collide']:play()
		end
		if ball.y<0 then
			ball.dy=-ball.dy
			ball.y=0
		end
		if ball.y>vlheight-4 then
			ball.y=vlheight-4
			ball.dy=-ball.dy
		end
		if ball.x<0 then
			servinglayer=1
			player2Score=player2Score+1
			ball:reset()
			audio['score']:play()
			gamestate='start'
			if player2Score==10 then
				winingplayer=2
				gamestate='done'
				audio['win']:play()
			end
		elseif ball.x>vlwidth then
			player1Score=player1Score+1
			ball:reset()
			servinglayer=2
			gamestate='start'
			audio['score']:play()
			if player1Score==10 then
				winingplayer=1
				gamestate='done'
				audio['win']:play()
			end
		end
	end
	if love.keyboard.isDown('w') then
		player1.dy=-paddle_speed
	elseif love.keyboard.isDown('s') then
		player1.dy=paddle_speed
	else
		player1.dy=0
	end
	if love.keyboard.isDown('up') then
		player2.dy=-paddle_speed
	elseif love.keyboard.isDown('down') then
		player2.dy=paddle_speed
	else
		player2.dy=0
	end
	if gamestate=='play' then
		ball:update(dt)
	end
	player1:update(dt)
	player2:update(dt)
end