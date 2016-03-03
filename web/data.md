---
layout: page
title: About Data
description: Georgia Tech big data bootcamp training material
---

Throughout the training exercises on this site we will use a small sample data set. If you followed the instructions documented on the [environment setup]({{ site.baseurl }}/environment) page to set up your environment, you will find the sample data in the `~/bigdata-bootcamp/data` folder in the virtual environment.

There are two data files with names `case.csv` and `control.csv` respectively. For the purpose of these exercises we will define patients who developed heart failure (HF) at some time point as case patients, and those who didn't develop HF as control patients.

Each line of the sample data file consists of a tuple structured as `(patient-id, event-id, timestamp, value)`, below are a few lines as an example:

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

- `patient-id` is just a patient identifier (id) in order to differentiate records from different patients. For example, the portion of data we show above is all about the same patient, who has an id of `020E860BD31CAC69`.
- `event-id` encodes all the clinical events that a patient has had. For example, `DRUG00440128228` indicates that the patient was taking a drug identified by a National Drug Code of `00440128228`. The numbers in `DIAG486` are the first 3 digits of an [ICD9 code](https://www.cms.gov/medicare-coverage-database/staticpages/icd-9-code-lookup.aspx), which in this case is the code for [Pneumonia](http://www.icd9data.com/2012/Volume1/460-519/480-488/486/486.htm). For this data an event-id of `PAYMENT` means that the patient made a payment with the corresponding dollar amount.
- `timestamp` indicates the date at which the event on that row happened. Here the timestamp is not formatted as a real date but rather as an offset from an unspecified start point. This is done both to improve the simplicity of processing and to protect the privacy of the patients' data.
- `value` is the associated value for an event. See the below table for a detailed description data in the value field.

|event type| sample `event-od`| value meaning| example|
|---------:|:-----------------|:-------------|:-------------|
|diagnostic code|DIAG486|Will always be `1.0` for diagnose events| 1.0 |
|drug consumption|DRUG00440128228|Dosage of the drug|30|
|payment|PAYMENT|Amount of payment made on `timestamp` date| 15000|
|heartfailure|heartfailure|Indicator of heart failure event| 1.0 |

{% comment %}
For `drug` the value corresponds to the drug dosage, for `payment` the value corresponds to the dollar amount of the payment, and for `diagnostic` events like `DIAG486` the value will always be `1` (which simply means the event happened and can be useful for counting events). The event `heartfailure` is a little bit different. You will find that the event `heartfailure` has `value` of `0` for control patients, and a `value` of `1` for case patients. The above sample data shows that patient `020E860BD31CAC69` was diagnosed with heart failure at timestamp 956.
{% endcomment %}
