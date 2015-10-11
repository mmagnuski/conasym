function mass_get_freq_asym(db)

ensure_opt;

db_len = length(db);
all_asym = cell(db_len, 1);

for r = 1:db_len
	out = get_freq_from_db(db, r);
	all_asym{r} = out.asym;
end

lens = cellfun(@length, all_asym);
if length(unique(lens)) > 1
    error(['Files are of different lengths. ',...
        'This is not implemented. Contact Miko ',...
        'for further assistance.']);
end
all_len = unique(lens);
all_asym = reshape([all_asym{:}], [db_len, all_len]);
fnms = {db.filename};

% out data format:
table = cell(size(all_asym) + 1);
table(2:end,1) = fnms';
table(1, 2:end) = num2cell(out.time);
table(2:end, 2:end) = num2cell(all_asym);

xlswrite(fullfile(opt.savepath, 'asym.xls'), table);