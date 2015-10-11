def.freq = 8:12;
def.chan = {'F3', 'F4' };
def.winlen = 1;
def.timestep = 0.2;
def.savepath = pwd;
def.asym = 'diff';

% check input
if ~exist('opt', 'var')
    opt = def;
else
	opt = parse_arse(opt, def);
end

if length(opt.freq) > 1 && length(opt.winlen) == 1
	opt.winlen = repmat(opt.winlen, [1, length(opt.freq)]);
end