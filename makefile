analyze:
	@flutter format . \
	&& flutter analyze \
	&& dart pub global run pana .