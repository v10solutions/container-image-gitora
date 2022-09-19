#
# Container Image Gitora
#

.PHONY: vol-create
vol-create:
	$(BIN_DOCKER) volume create "gitora"

.PHONY: vol-rm
vol-rm:
	$(BIN_DOCKER) volume rm "gitora"
