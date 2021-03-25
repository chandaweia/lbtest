done = function(summary, latency, requests)
   io.write("------------------------------\n")
   n_normal = summary.requests - summary.errors.status
   io.write(string.format("total normal requests = %d\n", n_normal))
   rps_normal = n_normal / (summary.duration/1000000)
   -- io.write(string.format("duration = %f s\n", (summary.duration/1000000) ))
   io.write(string.format("normal rps = %f\n", rps_normal))
   io.write("------------------------------\n")
   -- for _, p in pairs({ 50, 90, 99, 99.999 }) do
   --    n = latency:percentile(p)
   --    io.write(string.format("%g%%,%d\n", p, n))
   -- end
   for p = 1, 99, 1 do
      n = latency:percentile(p)
      io.write(string.format("CDF %d, %g\n", n, p))
   end
end
