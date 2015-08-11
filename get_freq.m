function freq_data = get_freq(EEG, opt)

% get_freq(db, r, opt)
% db - eegDb database
% r  - database entry to freq-torture
%
% opt:
% freq - frequencies to compute
% chan - channels to get freq from
% winlen - window length for each freq bin
% timestep - time step of the fft window

% defaults:
ensure_opt

% turn data to fieldtrip format
eeg = eeg2ftrip(EEG);

% glue the data together:
eeg.trial = {[eeg.trial{:}]};
n_samples = size(eeg.trial{1}, 2);
sample_step = 1 / eeg.fsample;
eeg.time  = {0:sample_step:(n_samples-1)*sample_step};
eeg.sampleinfo = [0, n_samples] + eeg.sampleinfo(1);

% create cfg
cfg.method     = 'mtmconvol';
cfg.taper      = 'hanning';
cfg.output     = 'pow';
cfg.channel    = opt.chan;
cfg.foi        = opt.freq;
cfg.toi        = 0:opt.timestep:eeg.time{1}(end);
cfg.t_ftimwin  = opt.winlen;

freq = ft_freqanalysis(cfg, eeg);

% temp:
freq_data = freq;