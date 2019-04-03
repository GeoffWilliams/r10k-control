onceover:
	cat Puppetfile > Puppetfile.onceover
	cat Puppetfile.mock >> Puppetfile.onceover
	bundle exec onceover run codequality
	bundle exec onceover run spec --puppetfile Puppetfile.onceover
	bundle exec onceover run metrics --format text
