-- example script that demonstrates adding a random
-- 10-50ms delay before each request

function delay()
   --wrk.thread:sleep(10000)
   return math.random(2000, 3000)
end
