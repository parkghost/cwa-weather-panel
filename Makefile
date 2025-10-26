.PHONY: release

release:
	@if [ -z "$(VERSION)" ]; then \
		echo "Error: VERSION parameter is required"; \
		echo "Usage: make release VERSION=x.y.z"; \
		exit 1; \
	fi; \
	echo "Preparing release for version $(VERSION)..."; \
	echo "Checking if tag $(VERSION) already exists..."; \
	if git rev-parse "$(VERSION)" >/dev/null 2>&1; then \
		echo "Error: Tag $(VERSION) already exists!"; \
		echo "Please use a different version or delete the existing tag."; \
		exit 1; \
	fi; \
	echo "Creating release $(VERSION)..."; \
	gh release create "$(VERSION)" --generate-notes; \
	echo "Release $(VERSION) completed successfully!"
