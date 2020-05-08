BEGIN {
   seqno = -1;
   recvdSize = 0;
   startTime = 400;
   stopTime = 100;
   maxpac_id=0;
   recevepkt = 0;
   sendspkt = 0;
   routingpkts = 0;
   receivespkt = 0;
   sum = 0;
   count = 0;
   packet_size =10;		
  }
   
  {
   tempo = $3;
   pac_id = $41;
   agt = $4;
   tcbr = $35;
   token19 = $4;
   token1 = $1;
   token35 = $35;
   event = $1;
   time = $2;
   node_id = $3;
   pkt_size = $8;
   level = $4;
   pktType = $7;
   

 
   if ( token1 == "s" && token19=="AGT" && pkt_size <= 10)
	sendspkt++;
   
   if ( (token1 == "s" || token1 == "f") && token19=="RTR")
	rountingpkts++;

   if ( event == "r" && agt=="AGT")
	recevepkt++;
   if ($1 == "D" && $7 == "cbr" && $8 >10)
        droppedPackets++; 	

   if ( pac_id > maxpac_id ) maxpac_id = pac_id;
   if ( ! ( pac_id in tempIn ) ) tempIn[pac_id] = tempo;
   if ( event != "d" ) {
        if ( event == "r" ) tempoFim[pac_id] = tempo;
   } else tempoFim[pac_id] = 0;



  
  # Store start time
  if (level == "AGT" && event == "s" && $8 <= 10) {
    if (time < startTime) {
             startTime = time;
            }
      } 
   
  # Update total received packets' size and store packets arrival time
  if ((level == "AGT") && (event == "r") && (pkt_size >= 10)) {
       if (time >= stopTime) {
             stopTime = time
             }
       # Rip off the header
       hdr_size = pkt_size % 10
       pkt_size -= hdr_size
       # Store received packet's size
       recvdSize +=pkt_size
       }
  if(seqno < $6){
    seqno = $6;	
    }
  #end-to-end delay
 if($4 == "AGT" && $1 == "s") {
 start_time[$6] = $2;
 } else if(($7 == "cbr") && ($1 == "r")) {
 end_time[$6] = $2;
 } else if($1 == "D" && $7 == "cbr") {
 end_time[$6] = -1;
 }

  }
END {
    for(i=0; i<=seqno; i++) {
    if(end_time[i] > 0) {
       delay[i] = end_time[i] - start_time[i];
       count++;
 }
 else
 {
 delay[i] = -1;
 }
 }
 for(i=0; i<count; i++) {
 if(delay[i] > 0) {
 n_to_n_delay = n_to_n_delay + delay[i];
 } 
 }
 n_to_n_delay = n_to_n_delay/count;

  
  for ( pac_id = 0; pac_id <= maxpac_id + 1; pac_id++ ) {
      duracao =  tempoFim[pac_id] - tempIn[pac_id];
      if ( duracao > 0 ) {
         
         sum = sum + duracao;
     }
  }

 

       printf("Average Throughput[kbps] = %.2f\t\t StartTime=%.2f\tStopTime=%.2f\trecvdSize=%.2f\n",(recvdSize/(stopTime-startTime))*(8/1000)"kbps",startTime"s",stopTime"s",recvdSize"bytes");
print "Generated packets =" seqno+1;
printf("Packets Sent = %d pkts\n", sendspkt);
  printf("Packets Received = %d pkts\n", recevepkt);
  #printf("Network Overhead = %d pkts\n", rountingpkts);
  printf("Packet Delivery Ratio = %f \n", (recevepkt/sendspkt)*100);
  print"Average End-to-End Delay = " n_to_n_delay * 1000 " ms";
 	print "Total Dropped Packets = " droppedPackets;
 print "Packet loss =",(((seqno+1)-(recevepkt))/100);
  }




