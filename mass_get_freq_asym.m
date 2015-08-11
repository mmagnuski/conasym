function mass_get_freq_asym(db, opt)

ensure_opt;

db_len = length(db);
all_asym = cell(db_len, 1);

for r = 1:db_len
	out = get_freq_from_db(db, r);
	all_asym{r} = out.asym;
end

lens = cellfun(@length, all_asym);
if unique(lens) > 1
    error(['Files are of different lengths. ',...
        'This is not implemented. Contact Miko ',...
        'for further assistance.']);
end
all_asym = [all_asym{:}];
fnms = {db.filepath};

% out data format:
table = cell(size(all_asym) + 1);
table(2:end,1) = fnms;
table(1, 2:end) = num2cell(out.time);
table(2:end, 2:end) = all_asym;

xlswrite(fullfile(opt.savepath, 'asym.xls'), table);