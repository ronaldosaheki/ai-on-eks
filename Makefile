.PHONY: run-precommit
run-precommit: copy-terraform-base-all
	pre-commit run -a

.PHONY: copy-terraform-base-all
copy-terraform-base-all:
	@for dir in $(shell find infra -name 'install.sh' -depth 2 | xargs -n 1 dirname | grep -v triton); \
		do cp -r infra/base/terraform/* $${dir}/terraform; \
	done;
