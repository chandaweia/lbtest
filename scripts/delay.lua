-- example script that demonstrates use of thread:stop()

--local counter = 1

function response()
   local r = math.random(1,2)
   os.execute("sleep " .. tonumber(r))
   --if counter == 100 then
   --   wrk.thread:stop()
   --end
   --counter = counter + 1
end
