function out = get_freq_from_db(db, r, opt)

ensure_opt
EEG = recoverEEG(db, r, 'local', 'interp');
freq = get_freq(EEG, opt);

% cut marginal NaNs
nans = isnan(squeeze(freq.powspctrm(1,1,:)));
freq.time = freq.time(~nans);
freq.powspctrm = freq.powspctrm(:,:,~nans);
hlfwinlen = freq.cfg.t_ftimwin(1) / 2;
freq_time_range = bsxfun(@plus, freq.time, ...
	[-hlfwinlen; hlfwinlen])';

% get bad epoch ranges:
which_mark = find(strcmp('reject', {db(r).marks.name}));
rej_ep = db(r).marks(which_mark).value';

ep_time_range = [1:length(rej_ep)] * db(r).epoch.winlen;
ep_time_range = [ep_time_range - db(r).epoch.winlen; ...
	ep_time_range]';

bad_timrange = ep_time_range(rej_ep, :);

% check which freq wins to remove:
num_freq_win = size(freq_time_range, 1);
remove_freqwin = false(num_freq_win, 3);

within = @(x, rng) x > rng(:,1) & x < rng(:,2);
around = @(x, rng) x(1) <= rng(1,:) & x(2) >= rng(2,:);

for f = 1:num_freq_win
	remove_freqwin(f,1) = any(within(freq_time_range(f,1), ...
		bad_timrange));
	remove_freqwin(f,2) = any(within(freq_time_range(f,2), ...
		bad_timrange));
	remove_freqwin(f,3) = any(around(freq_time_range(f,:), ...
		bad_timrange));
end

remove_freqwin = any(remove_freqwin, 2);

% average across freq
out.time = freq.time;
out.middle_freq = mean(freq.freq);
out.interp = remove_freqwin;
pow = mean(freq.powspctrm, 2);
chn_ind = reshape(find_elec(freq, {opt.chan{:}}), size(opt.chan));

% average across chans (left, right)
pow_l = mean(pow(chn_ind(:,1), :), 1);
pow_r = mean(pow(chn_ind(:,2), :), 1);

% compute asym
out.asym = asym(pow_l, pow_r, opt);

% interpolation
grps = group(remove_freqwin);
grps = grps(grps(:,1) == 1, :);
cnt = @(x) x(1) : x(2);
for g = 1:size(grps,1)
	interp_wins = cnt(grps(g, [2,3]));
	num = length(interp_wins);
	preind = interp_wins(1) - 1;
	postind = interp_wins(end) + 1;

	if preind <= 0
		preind = postind;
	end
	if postind > num_freq_win
		postind = preind;
	end

	pre = out.asym(preind);
	post = out.asym(postind);

	val = linspace(pre, post, num + 2);
	out.asym(interp_wins) = val(2:end-1);
end
