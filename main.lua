local cutoff, beta = 0.0004, 0.0007

local inp = {}
for x = 1, love.graphics.getWidth() do
  inp[x] = love.graphics.getHeight() * (0.5 + 0.3 * math.sin(x/100)) + love.math.randomNormal(5, 0)
end

local inpL = {}
local outL = {}
for x, y in ipairs(inp) do
  table.insert(inpL, x)
  table.insert(inpL, y)
  table.insert(outL, x)
  table.insert(outL, 0)
end

function love.draw()
  love.graphics.setColor({1,1,1})
  love.graphics.line(inpL)
  love.graphics.setColor({1,0,0})
  love.graphics.line(outL)
  love.graphics.print(string.format('cutoff: %1.5f', cutoff), 20, 20)
  love.graphics.print(string.format('  beta: %1.5f', beta), 20, 40)
end

function love.update()
  local filter = require 'dejitter' (cutoff, beta)
  for x, y in ipairs(inp) do
    outL[x * 2] = filter(x, y)
  end
end

-- modify filter parameters
function love.mousemoved(x,y)
  x = x / love.graphics.getWidth()
  y = y / love.graphics.getHeight()
  cutoff = math.exp(-x * 10)
  beta   = math.exp(-y * 10)
end
