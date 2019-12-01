-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- 320x480 
display.setStatusBar ( display.HiddenStatusBar )

local touch = 0
local hits = 0
local miss = 0
local perc = 0

background = display.newImageRect( "sky.jpg", display.contentWidth, display.contentHeight + 200 )
background.x = display.contentCenterX
background.y = display.contentCenterY

-- creating the bird
bird = display.newImageRect( "bird.png", 96, 52 )
bird.x = 70


-- Hits counter
hitsTxt = display.newText( "Hits: " .. hits, 50, 20, native.systemFont, 25 )
hitsTxt:setFillColor( 0, 1, 0 )

-- miss counter
missTxt = display.newText( "Miss: " .. miss, 160, 20, native.systemFont, 25)
missTxt:setFillColor( 1, 0, 0)

-- percent of hits
percTxt = display.newText( "Hit: " .. perc .. "%", 270, 20, native.systemFont, 25)
percTxt:setFillColor( 0, .5, 1 )

-- reset button
reset = display.newImageRect( "reset.png", 60, 30 )
reset.x = 280
reset.y = 450

-- setting up width and height of the screen
width = display.contentWidth
height = display.contentHeight

-- Variable for velocity of the bird falling
dyBird = 0

--gravity and bounce constants
gravity = 0.25
bounce = 0.7

burritos = {}
	burritos[1] = display.newImageRect( "burrito.png", 30, 20 )
	burritos[2] = display.newImageRect( "burrito.png", 30, 20 )
	burritos[3] = display.newImageRect( "burrito.png", 30, 20 )

for i = 1, 3 do
	b = burritos[i]
	b.x = 270 + ( i * 150 )
	b.y = math.random( 70, 395 )
end

-- function activates on every frame to check if the bird eats it
function checkHit()
	for i = 1, 3 do
		if  (burritos[i].x <= 130 and burritos[i].x >= 30)  --will only check when the burrito is near the birds mouth
		 and math.abs(bird.y - burritos[i].y) <= 52 then
			addHit()
			
		elseif (burritos[i].x == 75)
		 and math.abs(bird.y - burritos[i].y) > 52 then
			addMiss()
		end
	end
end

-- function for adding a hit
function addHit()
	hits = hits + 1
	hitsTxt.text = "Hits: " .. hits
	percCalc()
end

-- function for adding to the misses
function addMiss()
	miss = miss + 1
	missTxt.text = "Miss: " .. miss
	percCalc()
end

-- function for calculating the percent hit
function percCalc()
	perc = math.floor((( hits / (hits + miss) ) * 100) + .5 )
	percTxt.text = "Hit: " .. perc .. "%"
end

-- function used to move the bird down
function moveDown()
	if touch ~= 0 then
		bird.y = bird.y + dyBird
	else
		touch = 1
	end
	if bird.y > height - bird.height / 2 then    -- when the bird hits the ground
		bird.y = bird.y - dyBird
		dyBird = -dyBird * bounce
		-- resetGame()
	end
	dyBird = dyBird + gravity
end

--function called when the user taps the screen
function moveUp(event)
	if event.phase == "began" then
		touch = 1
		dyBird = -7
		--bird.y = bird.y - 40
		touch = 0
	end
	return true
end

-- function to move the objects left
function moveLeft()
	for i = 1, 3 do
		b = burritos[i]
		b.x = b.x - 1
		if b.x < -b.width then
			--b.x = width + b.width / 2
			b.x = 270 + 150
			b.y = math.random( 70, 430 )
		end
	end
	--checkHit()
end

function resetGame()
	hits = 0
	hitsTxt.text = "Hits: " .. hits
	miss = 0
	missTxt.text = "Miss: " .. miss
	perc = 0
	percTxt.text = "Hit: " .. perc .. "%"
end

function resetTouched( event )
	if event.phase == "began" then
		hits = 0
		hitsTxt.text = "Hits: " .. hits
		miss = 0
		missTxt.text = "Miss: " .. miss
		perc = 0
		percTxt.text = "Hit: " .. perc .. "%"
	end
	return true
end

Runtime:addEventListener( "enterFrame", moveLeft )

Runtime:addEventListener( "enterFrame", moveDown )

Runtime:addEventListener( "touch", moveUp )

reset:addEventListener( "touch", resetTouched )

Runtime:addEventListener( "enterFrame", checkHit )