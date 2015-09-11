---
layout: page
title: About Data
description: Georgia Tech big data bootcamp training material
---

Throughout this training, we will use a small sample data set. If you follow the instructions of [environment setup]({{ site.baseurl }}/environment), you will be able to find the sample data in `/bootcamp/data` folder.

There are two files, `case.csv` and `control.csv` respectively. We define patient who developed heart failure (HF) at some time point as case patient and who didn't develop HF as control patient.

Each line of the sample data file is a tuple with format `(patient-id, event-id, timestamp, value)` like

``` text
020E860BD31CAC69,DRUG36987254604,968,30.0
020E860BD31CAC69,DRUG64158080642,974,30.0
020E860BD31CAC69,DRUG00440128228,976,60.0
020E860BD31CAC69,DIAG486,907,1.0
020E860BD31CAC69,DIAG7863,907,1.0
020E860BD31CAC69,DIAGV5866,907,1.0
020E860BD31CAC69,DIAG3659,907,1.0
020E860BD31CAC69,DIAGRG199,907,1.0
020E860BD31CAC69,PAYMENT,907,15000.0
020E860BD31CAC69,heartfailure,956,1.0
```

- `patient-id` is just an identifier which don't have any meaning but to distinguish different patients. For example, the portion of data we shwo about is all about patient with id `020E860BD31CAC69`.
- `event-id` encodes what happened to a patient. For example, `DRUG00440128228` means a certain drug, `DIAG486` means been diagnoised with [Pneumonia](http://www.icd9data.com/2012/Volume1/460-519/480-488/486/486.htm) and `PAYMENT` means made a payment.
- `timestamp` shows when does the event happen. Here the timestamp is just an offset from an unspecified start point for simplicity of processing and for privacy of patients.
- `value` is associated value of event. For `drug` it means the dosage, for `payment` means amount and for `diagnostic` type event like `DIAG486` value equals `1` just means the event happened. The event `heartfailure` is a little bit differnt, for control patient, you will find event `heartfailure` have `value` equals `0` and for case patient equals `1`. The above sample data shows the patient `020E860BD31CAC69` was diagnoised with heart failure at timestamp 956.