---
layout: page
title: About Data
description: Georgia Tech big data bootcamp training material
---

Throughout this training, we will use a small sample data set. If you follow the instructions of [environment setup]({{ site.baseurl }}/environment), you will be able to find the sample data in `~/bigdata-bootcamp/data` folder.

There are two files, `case.csv` and `control.csv` respectively. We define patients who developed heart failure (HF) at some time point as case patients and who didn't develop HF as control patients.

Each line of the sample data file consists of a tuple with format `(patient-id, event-id, timestamp, value)` like

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

- `patient-id` is just a patient identifier (id) in order to differentiate records from different patients. For example, the portion of data we show above is all about patient with id `020E860BD31CAC69`.
- `event-id` encodes all the clinical events that a patient had. For example, `DRUG00440128228` means a drug with National Drug Code as `00440128228`, `DIAG486` means the first 3 digit [ICD9 code](https://www.cms.gov/medicare-coverage-database/staticpages/icd-9-code-lookup.aspx), which means [Pneumonia](http://www.icd9data.com/2012/Volume1/460-519/480-488/486/486.htm) in this case and `PAYMENT` means that the patient made a payment with the corresponding dollar amount.
- `timestamp` indicates the date at which the event happened. Here the timestamp is not real date but an offset from an unspecified start point for simplicity of processing and for privacy of patients.
- `value` is associated value of event. See below table for detailed description.

|event type| sample `event-od`| value meaning| example|
|---------:|:-----------------|:-------------|:-------------|
|diagnostic code|DIAG486|diagnosed with certain disease, value always be `1.0`| 1.0 |
|drug consumption|DRUG00440128228|dosage of drug|30|
|payment|PAYMENT| payment made on certain `timestamp`| 15000|
|heartfailure|heartfailure| indicator of heart failure event| 1 |

{% comment %}
For `drug` it means the dosage, for `payment` means dollar amount and for `diagnostic` type event like `DIAG486` value equals `1` just means the event happened. The event `heartfailure` is a little bit different, for control patient, you will find event `heartfailure` have `value` equals `0` and for case patient equals `1`. The above sample data shows the patient `020E860BD31CAC69` was diagnosed with heart failure at timestamp 956.
{% endcomment %}
