#!/bin/bash

virsh list

virsh snapshot-create-as SRV-1 snapshot-$(date +%Y%m%d) --description "Avant Security Onion"Domain snapshot snapshot-20260803 created
virsh snapshot-create-as SRV-2 snapshot-$(date +%Y%m%d) --description "Avant Security Onion"
virsh snapshot-create-as PfSense snapshot-$(date +%Y%m%d) --description "Avant Security Onion"
virsh snapshot-create-as SRV-backup snapshot-$(date +%Y%m%d) --description "Avant Security Onion"
