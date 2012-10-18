###vim ~/.gemrc
	---
	:update_sources: true
	:backtrace: false
	:benchmark: false
	:verbose: true
	:sources:
	- http://rubygems.org/
	- http://gems.github.com
	:bulk_threshold: 1000
	install: --no-ri --no-rdoc --env-shebang
	update: --no-ri --no-rdoc --env-shebang
