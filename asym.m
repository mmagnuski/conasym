function out = asym(l, r, opt)

switch opt.asym
case 'diff'
	out = l - r;
case 'div'
	out = l ./ r;
case 'diffdivbysum'
	out = (l - r) ./ (l + r);
end