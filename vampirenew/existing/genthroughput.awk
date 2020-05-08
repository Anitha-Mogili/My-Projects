BEGIN {
       recvdSize = 0
       startTime = 400
       stopTime = 0
  }
   
  {
             event = $1
             time = $2
             node_id = $33
             pkt_size = $8
             level = $4
             source = $3
             
   
  # Store start time
  if (level == "AGT" && event == "s" && pkt_size >= 10 ) {
    if (time < startTime) {
             startTime = time
             }
       }
   
  # Update total received packets' size and store packets arrival time
  if (level == "RTR" && event == "r" && pkt_size >= 10) {
       if (time > stopTime) {
             stopTime = time
             }
       # Rip off the header
       hdr_size = pkt_size % 10
       pkt_size -= hdr_size
       # Store received packet's size
       recvdSize += pkt_size
       }
  }
   
  END {
       printf("Average Throughput[kbps] = %.2f\t\t StartTime=%.2f\tStopTime=%.2f\n recvdSize=%.2f\n",(recvdSize/(stopTime-startTime))*(8/1000),startTime,stopTime,recvdSize)
  }
