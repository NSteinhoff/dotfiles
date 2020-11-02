local Session = {}

function Session:new(length)
    local o = setmetatable({}, self)
    self.__index = self
    local now = 0

    o.length = length
    o.start = os.time()
    o.last = os.time()

    return o
end

function Session:duration()
    return self.last - self.start
end

return Session
