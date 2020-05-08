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
set val(rp)     AODV                       ;# routing protocol
set val(x)      500                      ;# X dimension of topography
set val(y)      500                      ;# Y dimension of topography
set val(stop)   10.0                         ;# time of simulation end

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
#Create 40 nodes
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
for {set i 0} {$i<$val(nn)} {incr i} {
$ns at 2.0 "$n($i) setdest 499 499 5.0" 
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


#===================================
#        Agents Definition        
#===================================
proc attach-cbr-traffic { node sink size interval } {
	global ns
	set source [new Agent/UDP]
	#$source set class_ 2
	$ns attach-agent $node $source
	set traffic [new Application/Traffic/CBR]
	$traffic set packetSize_ $size
	$traffic set interval_ $interval
	$traffic attach-agent $source
	$traffic set rate_ 10kbps
	$ns connect $source $sink
	return $traffic
}
set nulla [new Agent/LossMonitor]

# Transmission from nodes to CH
	$ns attach-agent $n($dn) $nulla
	set cbr0 [attach-cbr-traffic $n($sn) $nulla 10 0.5]
$ns at 1.0 "$cbr0 start"
$ns at 10.0 "$cbr0 stop"
#$ns connect $udp0 $null0

#===================================
#        Applications Definition        
#===================================

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
