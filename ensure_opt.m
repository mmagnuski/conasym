def.freq = 8:12;
def.chan = {'E5', 'E6'; ...
			'E7', 'E8'};
def.winlen = 1;
def.timestep = 0.1;
def.savepath = pwd;
def.asym = 'diffdivbysum';

% check input
if ~exist('opt', 'var')
    opt = def;
else
	opt = parse_arse(opt, def);
end

if length(opt.freq) > 1 && length(opt.winlen) == 1
	opt.winlen = repmat(opt.winlen, [1, length(opt.freq)]);
end