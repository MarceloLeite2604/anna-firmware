#!/bin/bash

echo -e 'power on\n';
sleep 0.05;
echo -e 'discoverable on\n';
sleep 0.05;
echo -e 'pairable on\n';
sleep 0.05;
echo -e 'agent NoInputNoOutput\n';
sleep 0.05;
echo -e 'default-agent';
while [ 1 ];
do
    sleep 20;
done;

