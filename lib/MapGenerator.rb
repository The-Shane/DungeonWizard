#Author: Shane McDermott
#Created On: Jun 12, 2016

class Room
	attr_accessor :x, :y, :width, :height
	def initialize(x,y,width,height)
		@x = x;
		@y = y;
		@width = width;
		@height = height;
	end
end

class MapGenerator
	attr_reader :rooms
	
	def initialize(height = 32, width = 24)
		@height = height
		@width = width
		@numberOfEncounters = 0;
		@grid = Array.new(@height);
		@rooms = Array.new(6);
		
		@height.times do |x|
			@grid[x] = Array.new(@width);
			@width.times do |y|
				@grid[x][y] = :wall;
			end
		end
	end

	def createMap
		addRoom
	end

	#TODO: Add Gap for Walls?
	def isSpaceAvailable(x0,y0,x1,y1)
		if(x0 >= 0 && y0 >= 0 && x1 < @height && y1 < @width)
			for x in (x0..x1) do
				for y in (y0..y1) do
					if(@grid[x][y] != :wall)
						return false;
					end
				end
			end
			return true;
		end
		return false;
	end

	private def addRoom(x = 0, y = 0, rmHeight = rand(4..6), rmWidth = rand(4..6))
		xBounds = x+rmHeight;
		yBounds = y+rmWidth;
		if(isSpaceAvailable(x,y,xBounds,yBounds))
			addSection((x..xBounds), (y..yBounds), "%02d" % [@numberOfEncounters])
			@rooms[@numberOfEncounters] = Room.new(x,y,rmWidth, rmHeight);
			@numberOfEncounters += 1;
			
			#Add South Rooms
			nextX = xBounds + rand(2..4);
			nextY = y + rand(2..4);
			addLinkedRoom(	nextX, 
							y, 
							(xBounds + 1...nextX),
							(nextY..nextY)
						  );
						  
			#Add East Rooms
			nextX = x + rand(2..4);
			nextY = yBounds + rand(2..4);
			addLinkedRoom(	x,
							nextY,
							(nextX..nextX),
							(yBounds + 1...nextY)
				);

			return true;
		else
			return false;
		end
	end
	
	private def addLinkedRoom(x,y,passageX, passageY)
		if(addRoom(x,y))
			addSection(passageX, passageY)
		end
	end

	#Fills a square region
	private def addSection(xRange, yRange, type = :passage)
		for rx in xRange do
			for ry in yRange do
				@grid[rx][ry]=type;
			end
		end
	end
	
	def getRow(row)
		str = ""
		@width.times do |y|
			str << @grid[row][y]
		end
		return str;
	end
	
	def getCell(row,col)
		return @grid[row][col]
	end
	
	def to_s
		str = ""
		@height.times do |y|
			@width.times do |x|
				str << @grid[y][x]
			end
			str << "\n"
		end
		return str;
	end
end


