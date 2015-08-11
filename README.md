# conasym
Continuous asymmetry with interpolation of missing data. Uses eegDb to organize data.

## Requirements
You need to have following packages:
* [fieldtrip](https://github.com/fieldtrip/fieldtrip)
* eeglab
* [eegDb](https://github.com/mmagnuski/eegDb)
* [braintools] (https://github.com/mmagnuski/braintools)

The data stored in your `eegDb` database must be continuous (consecutive windowing of continuous signal), windows marked for rejection should be marked with 'reject' mark but not actually rejected (the mark type should not be applied as rejection).

## Usage
You can get continuous asymmetry (with linear interpolation of data marked as 'reject' in the `eegDb`) to excel file this way:
```matlab
% define options
opt.freq = 7:13;
opt.winlen = 1; % timewindow length
opt.chan = {'left_channel_01', 'right_channel_01'; ...
            'left_channel_02', 'right_channel_02'};
opt.asym = 'diffdivbysum'; % compute asymmetry by power difference divided by sum of power
opt.savepath = 'C:\Users\EvilScientist\asymmetry results'

% run the analysis on all data:
mass_get_freq_asym(db, opt); % db is your eegDb database
```
