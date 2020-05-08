BEGIN {
i=0;
energy_left[50] = 10.000000;
total_energy_consumed = 0.000000;
consumed[50]=0.000000;
}

{
state = $1;
time = $3;
node_num = $5;
energy_level = $7;

if(state == "N") {
for(i=0;i<50;i++) {
if(i == node_num) {
energy_left[i] = energy_left[i] - (energy_left[i] - energy_level);
}

}
}

}

END {


for(i=0;i<50;i++) {
printf("%d %.6f \n",i, energy_left[i]) > "energyleft2.txt";
total_energy_consumed = total_energy_consumed + energy_left[i];
consumed[i]=(10-energy_left[i]);
printf("%d %.6f \n",i, consumed[i]) > "consumed2.txt";

}

# change 36 to number of nodes
printf("Total Energy Consumed : :%.6f\n", (50*10)-total_energy_consumed);
printf("Avg Energy Consumption : : :%.6f\n", ((50*10)-total_energy_consumed)/100);
printf("Overall Residual Energy: :%.6f\n", total_energy_consumed);

printf("Avg Residual Energy : :%.6f\n", total_energy_consumed/100);

# Below change 36 to number of nodes
printf("Protocol Energy Consumption :%.6f\n", 10.000000-((total_energy_consumed/(50*10.000000))*10.000000));
}

