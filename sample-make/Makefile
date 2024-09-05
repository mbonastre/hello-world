#
# Makefile template
#

EX_LIST=Example1 Example2

default: help  ## Default action (help) prints list of documented targets

example: ## Executes example actions
example: $(foreach ex,$(EX_LIST),.do_example_$(ex))

define exampleFunction
  echo "exampleFunction: target=$1/$@, wild=$2/$*, $3, $4"
endef

# Example wildcard rule
.do_example_%:
	echo "Normal command: target=$@; wildcard=$*"
	$(call exampleFunction,$@,$*,"More parameters", "Even more parameters")

#
# Help magic
#
help: ## show this help message
	@awk \
	'BEGIN {FS = ":.*##"; printf "Usage: make [target] \033[36m\033[0m\n"} \
	/^[$$()% 0-9a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
	/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' \
	$(MAKEFILE_LIST)

