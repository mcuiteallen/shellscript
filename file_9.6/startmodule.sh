#!/bin/bash
sudo systemctl start start_gee
sleep 3
sudo systemctl start start_cserver
sleep 3
sudo systemctl start start_nserver
sleep 3
sudo systemctl start start-quartz
sleep 3
sudo systemctl start start_edge
sleep 3
sudo systemctl start start_inlight
sleep 3
sudo systemctl start start_inems
sleep 3
sudo systemctl start start-ec
sleep 3
sudo systemctl start start-ecbj
sleep 3
sudo systemctl start start-isas
sleep 3
sudo systemctl start start-if3
sleep 3
sudo systemctl start start-auth
sleep 3
sudo systemctl start start_chart
sleep 3
sudo systemctl start start-obsidian
sleep 3
sudo systemctl start start-statistic
sleep 3
sudo systemctl start start-statistic-cache
sleep 3
sudo systemctl start start_node