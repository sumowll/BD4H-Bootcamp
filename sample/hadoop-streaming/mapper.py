#!/usr/bin/env python

import sys

for line in sys.stdin:
    line        = line.strip()
    splits      = line.split(',', 3)

    if len(splits) < 4:
        # ignore problemactic line
        continue

    # unwind the splits
    patient_id, event_name, date_offset, value = splits

    # emit key-value pair seperated by \t
    print event_name + '\t1'