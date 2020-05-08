#===================================
#     Simulation parameters setup
#===================================
puts "Enter number of nodes"
set nn1 [gets stdin]

set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    CMUPriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 50                         ;# max packet in ifq
set val(nn)     $nn1                         ;# number of mobilenodes
set val(rp)     PLGP                       ;# routing protocol
set val(x)      500                      ;# X dimension of topography
set val(y)      500                      ;# Y dimension of topography
set val(stop)   20.0                         ;# time of simulation end

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

#Open the NS trace file
set tracefile [open out.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel

#===================================
#     Mobile node parameter setup
#===================================
$ns node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -channel       $chan \
                -topoInstance  $topo \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      ON \
                -movementTrace ON \
		-energyModel EnergyModel \
		-idlePower 0.035 \
			 -rxPower 0.0395 \
			 -txPower 0.066 \
			 -sleepPower 0.000015 \
	 		 -initialEnergy 10 	



#===================================
#        Nodes Definition        
#===================================

for {set i 0} {$i < $val(nn)} {incr i} {
set n($i) [$ns node]
}
for {set i 0} {$i < $val(nn)} {incr i} {
      #set n($i) [$ns node]
	
       $n($i) set X_ [expr rand()*$val(x)]
         #set X_ [expr rand()*$val(x)]
	$n($i) set Y_ [expr rand()*$val(y)]
       # puts $nd "n($i) set X_ [expr rand()*$val(x)]" 
        #puts $nd "n($i) set Y_ [expr rand()*$val(y)]"
	#set Y_ [expr rand()*$val(y)]
}
for {set i 0} {$i < $val(nn) } {incr i} {
 $ns initial_node_pos $n($i) 30
 }

proc lrandom L {
	lindex $L [expr {int(rand()*[llength $L])}]
}

proc myRand { min max } {
    set maxFactor [expr [expr $max + 1] - $min]
    set value [expr int([expr rand() * 100])]
    set value [expr [expr $value % $maxFactor] + $min]
return $value
}
for {set i 0} {$i<$val(nn)} {incr i} {
	$n($i) color yellowgreen
	# $ns at 0.0 "$n($i) color purple"
}
for {set i 0} {$i<$val(nn)} {incr i} {
$ns at 2.0 "$n($i) setdest 499 499 5.0" 
}


#Neighbour selection algorithm
for {set i 0} {$i<$val(nn)} {incr i} {
	set NL($i) [list]
	set x_pos1 [$n($i) set X_]
	set y_pos1 [$n($i) set Y_]
	for {set j 0} {$j<$val(nn)} {incr j} {
		if {$j!=$i} {
			set x_pos2 [$n($j) set X_]
			set y_pos2 [$n($j) set Y_]
			set x_pos [expr $x_pos1-$x_pos2]
			set y_pos [expr $y_pos1-$y_pos2]
			set v [expr $x_pos*$x_pos+$y_pos*$y_pos]
			set d [expr sqrt($v)]
			set nd($i,$j) $d
			#puts "Distance from $i to $j:$d"
			if {$d<250} {
				$n($i) add-neighbor $n($j)
			}
		}
	}
	set neighbor1 [$n($i) neighbors]
	foreach nb1 $neighbor1 {
		set now [$ns now]
#		puts "The neighbour for node $i are:$nb1"
		set idv [$nb1 id]
		puts "$idv"	
		lappend NL($i) $idv
	}
}

set flag1(0) true
set flag1(1) true
set flag1(2) true
set flag1(3) true
set flag1(4) true
set flag1(5) true
set flag1(6) true
set flag1(7) true
set flag1(8) true
set flag1(9) true
set flag1(10) true
set flag1(11) true
set flag1(12) true
set flag1(13) true
set flag1(14) true
set flag1(15) true
set flag1(16) true
set flag1(17) true
set flag1(18) true
set flag1(19) true
set flag1(20) true
set flag1(21) true
set flag1(22) true
set flag1(23) true
set flag1(24) true
set flag1(25) true
set flag1(26) true
set flag1(27) true
set flag1(28) true
set flag1(29) true
set flag1(30) true
set flag1(31) true
set flag1(32) true



puts "Enter the source node ID (5-$val(nn))"
set sn [gets stdin]
while {$sn>$val(nn)} {
	puts "Enter the value in between 5 and $val(nn)"
	flush stdout
	set sn [gets stdin]
}

puts "Enter the destination node ID (5-$val(nn))"
set dn [gets stdin]
while {$dn>$val(nn) || $sn==$dn} {
	puts "Enter the value in between 5 and $val(nn)"
	flush stdout
	set sn [gets stdin]
}

$ns at 0.0 "$n($sn) label Source"
$ns at 0.0 "$n($dn) label Destination"
#### Attacks lis
$ns at 6.0 "[$n(0) set ragent_] vampire"
$ns at 6.0 "[$n(1) set ragent_] carousel"
$ns at 6.0 "[$n(2) set ragent_] stretch"

set ml [list]
for {set i 0} {$i<5} {incr i} {
	set mn [myRand 0 $val(nn)]
	if {$mn!=$sn && $mn!=$dn} {
		lappend ml $mn
		$ns at 0.0 "$n($mn) add-mark mb black"
	}
}
set rtbd $sn
while {$rtbd==$dn || $rtbd==$sn} {
	set rtbd [lrandom $NL($sn)]
}
$ns at 0.0 "$n($rtbd) label Detector"
$ns at 0.0 "$n($rtbd) add-mark m0 yellowgreen square"
set time 0.0
for {set i 0} {$i<$val(nn)} {incr i} {
	set fl($i) 0
	set flg($i) 0
}

#______________________________________________________
	for {set des 0} {$des<$val(nn)} {incr des} {
		for {set j 0} {$j<$val(nn)} {incr j} {
			if {$des!=$j} {
				for {set i 0} {$i<$val(nn)} {incr i} {
					set flg($i) 0
				}
				set s $j
				set flag 0
				set RN $s
				lappend route($j,$des) $j
				while {$RN!=$des} {
					foreach rn $NL($RN) {
						if {$rn==$des} {
							set flag 1
						}
					}
					if {$flag==1} {
						set RN1 $des
					} else {
						set x_pos1 [$n($des) set X_]
						set y_pos1 [$n($des) set Y_]
						set dL [list]
						set t [$ns now]
						foreach rnod $NL($RN) {
							set x_pos2 [$n($rnod) set X_]
							set y_pos2 [$n($rnod) set Y_]
							set x_pos [expr $x_pos1-$x_pos2]
							set y_pos [expr $y_pos1-$y_pos2]
							set v [expr $x_pos*$x_pos+$y_pos*$y_pos]
							set D2 [expr sqrt($v)]							
							lappend dL $D2
							set dis($des,$rnod) $D2
						}
						set dis1 [lsort -real $dL]
						set mindis [lindex $dis1 0]
						foreach ni $NL($RN) {
								if {$mindis==$dis($des,$ni)} {
									set RN1 $ni
									set flg($ni) 1
								}
						}
					}
					set RN $RN1
					lappend route($j,$des) $RN
					# break
				}
			}			
		}
	}
#______________________________________________________
	
proc attach-cbr-traffic {node sink size interval} {
	global ns
	set source [new Agent/UDP]
	$source set class_ 2
	$ns attach-agent $node $source
	set traffic [new Application/Traffic/CBR]
	$traffic set packetSize_ $size
	$traffic set interval_ $interval
	$traffic attach-agent $source
	$ns connect $source $sink
	return $traffic
}
foreach nl $NL($sn) {
	lappend nnl $nl
}
set nnl [linsert $nnl 0 $sn]

foreach i $nnl {
	set flg($i) 1
}
set RREPList [list]
set pdn 0
set fl($sn) 1
#Broadcast Forward packet
while {$pdn==0} {
	foreach i $nnl {
		set flg($i) 1
		foreach cn $NL($i) {
				if {$fl($cn) != 1} {
					set null1 [new Agent/LossMonitor]
					$ns attach-agent $n($cn) $null1
					set cbr [attach-cbr-traffic $n($i) $null1 10 0.05]
					$ns at $time "$n($cn) add-mark m1 purple"
					$ns at $time "$ns trace-annotate \"The node $i broadcast the RREQ' packets to its neighbour node $cn \""
					$ns at $time "$cbr start"
					set fl($cn) 1
					$ns at [expr $time+0.1] "$cbr stop"
	
				set time [expr $time+0.1]
				if {$cn==$dn} {
					set pdn 1
				}
				if {$flg($cn)==0} {
					lappend nnl $cn
				}
				if {($cn==$rtbd) && ([lsearch $ml $rtbd]==-1)} {
					set null2 [new Agent/LossMonitor]
					$ns attach-agent $n($sn) $null2
					set cbr1 [attach-cbr-traffic $n($cn) $null2 10 0.05]
					$ns at $time "$n($cn) delete-mark m1"
					$ns at $time "$n($cn) add-mark m2 blue"
					$ns at $time "$ns trace-annotate \"The node $cn send the RREP to the source node $sn \""
					$ns at $time "$ns trace-annotate \"Address List:$route($sn,$rtbd) \""
					$ns at $time "$cbr1 start"
					$ns at [expr $time+0.5] "$cbr1 stop"
					lappend RREPList $cn
					set time [expr $time+0.5]
				} elseif {($cn==$rtbd) && ([lsearch $ml $rtbd]>=0)} {
					$ns at $time "$n($cn) color red"
					$ns at $time "$n($cn) label attacker"
				}
				if {($cn!=$rtbd) && ([lsearch $ml $cn]>=0)} {
					set null3 [new Agent/LossMonitor]
					$ns attach-agent $n($sn) $null3
					set cbr2 [attach-cbr-traffic $n($cn) $null3 10 0.05]
					$ns at $time "$n($cn) delete-mark m1"
					$ns at $time "$n($cn) add-mark m2 blue"
					$ns at $time "$ns trace-annotate \"The node $cn send the RREP to the source node $sn \""
					set droute($sn,$cn) $route($sn,$cn)
					lappend droute($sn,$cn) $rtbd
					$ns at $time "$ns trace-annotate \"Address List:$droute($sn,$cn) \""
					$ns at $time "$cbr2 start"
					$ns at [expr $time+0.5] "$cbr2 stop"
					lappend RREPList $cn
					set time [expr $time+0.5]
				}
				}
			}
	}
}

$ns at $time "$ns trace-annotate \"The source node $sn receives RREP from the following nodes\""
$ns at $time "$ns trace-annotate \"$RREPList\""
proc trust {} {
   
{
                set file*data=(file*)dwld.data udp;
                set node = neighbornode_rep;                          
                set receiving time = rt(file*data);
                set transmission time=tt(mag*data);
                set allocator->node_()(file*data);
                set counter=1->configure timer 
                set sends=(file*)dwld.data udp;
                set recvs=(file*)dwld.data udp;
                set ipaddress=id "";              
                select timer="";                 
                
}
  if (trusted_authority())
	{
	        file*data=(file*)dwld.data udp;
                sink = new_node_rep;
                allocator= node_->ip;
                pub_key=i;
                pri_key=j;
                sign->offer iP(i,j);   
                            
                init_sink->address_alloc[0];
                config_(rp)set $ns address alloc;

                     file*data=(file*)dwld.data udp;
                
                

	}
           else
                   {
                set $ns "no authentication" at "";
                   }

                if( threshold > 0.5)
              {
                select "$ns node_()file*data;
                select timer $ns at "";
                puts "$node_()-attacker_node add_mark . red circle"
                
                update timer ();
               }

                else
               {
                 select skip;
                }


 {

    }
}

proc d_trv {node_config} {
     if(node_().trv_upd=true)
{
     a=node_weight*loadtime udp;
     b=file_chktime*(1-weight) udp;
     c=a+b;
}

}

proc id_trv {node_config} {
     if(node_().idtrv_upd=true)
{
     r=feedback_crdn*data udp;
     s=d_trv udp;
     t=r+s;
}
}

proc En_calc {tx_dr Rx_dr p_s N_type N_node } {
global  tx_power Rx_power Count_time Curr_Energy
set tx_rx_time 0.001
set tx_data_rate [expr [lindex [split $tx_dr "M"] 0]*1000000]
#puts $Rx_dr
set Rx_data_rate [expr [lindex [split $Rx_dr "M"] 0]*1000000]
set Pkt_size [expr $p_s*1000] 
if {$N_type == 1 } {

set n_tx_pkts [expr $tx_data_rate/$Pkt_size]
set n_Rx_pkts [expr $Rx_data_rate/$Pkt_size]
set Tx_decr_power [expr $n_tx_pkts*$tx_power]
set Rx_decr_power [expr $n_Rx_pkts*$Rx_power*($N_node-1)]
set Curr_Energy [expr $Curr_Energy-(($Tx_decr_power*$tx_rx_time + $Rx_decr_power*$tx_rx_time)*$Count_time)]
} else { 
set n_tx_pkts [expr $tx_data_rate/$Pkt_size]
set Tx_decr_power [expr $n_tx_pkts*$tx_power]
set Curr_Energy [expr $Curr_Energy-($Tx_decr_power*$tx_rx_time*$Count_time)] 
}
set Curr_Energy [expr $Curr_Energy]


#puts "==========================>$Curr_Energy"
return En_calc

}
for {set v 0} {$v<$val(nn)} { incr v} {
set node_current_energy($v) 10
}

set tx_power 1
set Rx_power 0.5
set Count_time 2

proc lreverse {l} {
	set m [list]
	foreach i $l {
		set m [linsert $m 0 $i]
	}
	return $m
}
	
proc splitList {list1 en list2} { 
	set ip [lsearch $list1 $en]
	set ll [llength $list1]
	for {set i 0} {$i<$ll} {incr i} {
		set elt1 [lindex $list1 $i]
		if {$i<=$ip} {
			lappend $list2 $elt1
		} else {
			lappend sp2($en) $elt1
		}
	}
	return $sp2($en)
}

proc intersection {a b} {
   foreach el $a {set arr($el) ""}
   set res {}
   foreach el $b {if {[info exists arr($el)]} {lappend res $el}}
   set res
}
proc set'remove {_set args} {
   upvar 1 $_set set
   foreach el $args {
       set pos [lsearch -exact $set $el]
       set set [lreplace $set $pos $pos]
   }
   set set
}
proc difference {a b} {
   eval set'remove a $b
}
# Secured forwarad packet

foreach nir $RREPList {
	if {$nir!=$rtbd} {
	set soc $sn
		set null4 [new Agent/LossMonitor]
		$ns at $time "$ns trace-annotate \"The node $sn recheck the node $nir \""
		foreach inir $route($sn,$nir) {
			$ns attach-agent $n($inir) $null4
			set cbr3 [attach-cbr-traffic $n($soc) $null4 10 0.05]
			$ns at $time "$n($inir) add-mark m4 yellow"
			$ns at $time "$cbr3 start"
			$ns at [expr $time+0.5] "$cbr3 stop"
			$ns at [expr $time+0.5] "$n($inir) delete-mark m4"
			set soc $inir
		}
		set time [expr $time+0.5]
		set revroute [lreverse $route($sn,$nir)]
		set soc1 $nir
		set argslist [list]
		foreach rev $revroute {
			$ns attach-agent $n($rev) $null4
			set cbr4 [attach-cbr-traffic $n($soc1) $null4 10 0.05]
			$ns at $time "$n($rev) add-mark m5 orange"
			$ns at $time "$cbr4 start"
			$ns at $time "$ns trace-annotate \"The node $rev send RREP with address list P={$droute($sn,$nir)} \""
			$ns at [expr $time+0.1] "$cbr4 stop"
			$ns at [expr $time+0.1] "$n($rev) delete-mark m4"
			if {$rev!=$nir} {
				set sp($rev) [list]
				set k($rev) [splitList $droute($sn,$nir) $rev $sp($rev)]
				$ns at $time "$ns trace-annotate \"The node $rev split the address list into two\""
				$ns at $time "$ns trace-annotate \"K$rev' value is: $k($rev)\""
			}
			set time [expr $time+0.1]
			set soc1 $rev
		}
		set elv [lindex $revroute 1]
		set el $k($elv)
		foreach rev1 $revroute {
			if {$rev1!=$nir} {
			set ril $k($rev1)
			puts "el:$el"
			puts "ril:$ril"
			set value($nir) [intersection $ril $el]
			set el $k($rev1)
			}
		}
		puts "value($nir):$value($nir)"
		# set dmn [difference $droute($sn,$nir) $value($nir) ]
		set dmn [lindex $value($nir) 0]
		$ns at $time "$n($dmn) color red"
		$ns at $time "$n($dmn) label attacker"
		$ns at $time "$ns trace-annotate \"K$rev' value is: $k($rev)\""
		$ns at $time "$ns trace-annotate \"The source node detected that $dmn is a attacker node\""
	}
}

#Route the data packets from source to destination
puts "broute($sn,$dn):$route($sn,$dn)"
foreach inode $route($sn,$dn) {
	if {[lsearch $ml $inode]>=0} {
		set pos [lsearch -exact $route($sn,$dn) $inode]
		set set [lreplace $route($sn,$dn) $pos $pos]
	}
}
puts "aroute($sn,$dn):$route($sn,$dn)"
set snode $sn
set null5 [new Agent/LossMonitor]
$ns at $time "$ns trace-annotate \"The source node transmit the message to the destination via\""
foreach rnode $route($sn,$dn) {
	$ns attach-agent $n($rnode) $null5
	set cbr4 [attach-cbr-traffic $n($snode) $null5 10 0.05]
	$ns at $time "$n($rnode) add-mark m5 green"
	$ns at $time "$ns trace-annotate \"$rnode\""
	$ns at $time "$cbr4 start"
	$ns at [expr $time+5.5] "$cbr4 stop"
	set snode $rnode
}

#Performance evaluation
set nps 0
#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam out.nam &
    exit 0
}
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "\$n($i) reset"
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
