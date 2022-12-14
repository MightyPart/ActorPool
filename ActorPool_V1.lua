local ActorPool = {}
ActorPool.__index = ActorPool

local ActorPoolInsts = {}
ActorPoolInsts.__index = ActorPoolInsts

local function createActor(pool)
	local newActor = pool.baseActor:Clone()
	newActor.Name = newActor.Name.."-"..pool.actorCount; pool.actorCount += 1
	newActor:SetAttribute("doingTask", false)

	newActor:GetAttributeChangedSignal("doingTask"):Connect(function()
		if newActor:GetAttribute("doingTask") then return end
		table.insert(pool.available, newActor)
	end)

	newActor.Parent = pool.folder
	return newActor
end

function ActorPool.New(actor, folder, amount)
	local pool =  setmetatable({
		available = nil,
		baseActor = actor,
		folder=folder,
		actorCount = 1
	}, ActorPoolInsts)

	local actors = table.create(amount)
	for count = 1,amount do
		local newActor = createActor(pool)
		table.insert(actors, newActor)
	end

	pool.available = actors

	return pool
end

function ActorPoolInsts:Take()
	return table.remove(self.available) or createActor(self)
end

return ActorPool
