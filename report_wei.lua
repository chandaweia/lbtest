-- example reporting script which demonstrates a custom
-- done() function that prints latency percentiles as CSV

done = function(summary, latency, requests)
	io.write("--------------Summary----------------\n")
	print(summary)
	for i = 1, summary.requests, 1 do
        	if latency[i] ~= 0 then
            	io.write(string.format("%d\n", latency[i]))
	        else
        	    break
	        end
    	end
	io.write("---------------Latency---------------\n")
	print(latency)
	io.write("---------------requests---------------\n")
	print(requests)
end
