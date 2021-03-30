--  Usage: wrk --latency -d20s -t1 -c1 -s extra-stats.lua https://u6n3khzh85.execute-api.us-east-1.amazonaws.com/testhello

-- This adds a 100ms delay after each failed request (status code > 200), the
-- purpose of this is to back off and try to limit the number of bad requests
-- At the end of the run it prints the latency for ALL requests and the
-- "goodput" calculated by only considering successful requests.
-- Latency data is reported in microseconds

-- Known Issue: The latencies reported include failed requests and they do not
-- include some requests which wrk records as 0 latency. It is unclear why that
-- happens or whether it impacts the latency distribution numbers. 

function response()
   local r = math.random(1,2)
   os.execute("sleep " .. tonumber(r))
end

function done(summary, latency, requests)
    io.write("## LATENCIES \n")
    -- Print all latency measurements
    -- WARNING: this includes failed requests too!
    for i = 1, summary.requests, 1 do
        if latency(i) ~= 0 then
            io.write(string.format("%d\n", latency(i))) 
        else
            break
        end
    end
    
    io.write("\n## PERCENTILES \n")
    for p = 1, 99, 1 do
        n = latency:percentile(p)
        io.write(string.format("%g %d\n", p, n))
    end
    for _, p in pairs({ 99.9, 99.99, 99.999 }) do
        n = latency:percentile(p)
        io.write(string.format("%g %d\n", p, n))
    end
    
    io.write("\n## SUMMARY \n")
    io.write(string.format("Latency min/25/50/75/99/max:\t%d\t%d\t%d\t%d\t%d\t%d\tmicrosec\n", latency.min, latency:percentile(25), latency:percentile(50), latency:percentile(75), latency:percentile(99), latency.max))
    io.write(string.format("Total Reqs:\t%d\tPass:\t%d\tFail:\t%d\tRate:\t%f\treq/sec\n", 
        summary.requests, (summary.requests - summary.errors.status), summary.errors.status, 
        (summary.requests - summary.errors.status)/summary.duration*1000000))
end
