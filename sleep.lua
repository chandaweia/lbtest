--local socket = require("socket")
local n = 30000
function Sleep(n)
   os.execute("sleep " .. n)
   --socket.sleep(3)
end
