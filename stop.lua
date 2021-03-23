-- example script that demonstrates use of thread:stop()

local counter = 1

function response()
   wrk.thread:sleep(1000000)
   if counter == 10000 then
      wrk.thread:stop()
      --wrk.thread:sleep(1000000)
   end
   counter = counter + 1
end
